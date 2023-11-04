#!/usr/bin/perl
use strict;
use warnings;

use JSON::XS qw(decode_json encode_json);
use MIME::Lite;
use Mojo::UserAgent;
use Mojo::Util qw(getopt dumper);
use Path::Tiny;

use constant ARCH_SECURITY => 'https://security.archlinux.org/issues/all.json';
use constant MAIL_SERVER   => 'mail.sko.ai';
use constant IMAGE_FILTER  => qr{ghcr[.]io/vaskozl};
use constant SA_TOKEN      => '/var/run/secrets/kubernetes.io/serviceaccount/token';

getopt
  'u|upgradable' => \my $upgradeable,
  'm|mailto=s'   => \my $mail_to,
  'f|from=s'     => \my $mail_from,
  'v|verbose'    => \my $verbose;

my $ua = Mojo::UserAgent->new->insecure(1);
my $token = path(SA_TOKEN)->slurp;
my $k8s_api = 'https://kubernetes.default.svc.cluster.local';

sub _get_vulns {
  my $avgs = $ua->get(ARCH_SECURITY)->result->json;
  die "No vulnerabilities found in " . ARCH_SECURITY unless @$avgs;
  return $avgs;
}

sub _k8s_headers { { 'Authorization' => "Bearer $token", 'Accept' => 'application/json' } }

sub _installed_packages {
  my $pod_data = $ua->get($k8s_api .
    '/api/v1/pods?fieldSelector=status.phase=Running',
    _k8s_headers
  )->result->json;

  my %pacman_q;
  my %processed_images;
  for my $pod (@{$pod_data->{items}}) {
      my $namespace = $pod->{metadata}{namespace};
      my $pod_name = $pod->{metadata}{name};

      # Get the list of containers in the pod
      my @containers = @{$pod->{spec}{containers}};

      for my $container (@containers) {
          my $container_name = $container->{name};
          my $container_image = $container->{image};
          next if $pacman_q{$container_image};

          # Check if the image name contains "vaskozl"
          if ($container_image =~ IMAGE_FILTER) {
            print "Scanning $container_image\n" if $verbose;
            # TODO: Use wss instead of shelling out
            my @lines = `kubectl exec -n "$namespace" "$pod_name" -c "$container_name" -- pacman -Q`;
            warn "Could not enumerate packages in $container_image" unless @lines;
            for (@lines) {
              my ($name, $ver) = split;
              $pacman_q{$container_image}{$name} = $ver;
            }
          }
      }
  }
  \%pacman_q
}

sub _generate_report {
  my ($ctrs, $avgs) = @_;
  my $report;

  for my $ctr (keys %{$ctrs}) {
    my %installed = %{$ctrs->{$ctr}};
    my $ctr_message;
    for my $name (keys %installed) {
      for my $avg (@$avgs) {
        if (grep { $name eq $_ } @{$avg->{packages}}) {
          next if $avg->{status} eq "Not affected";
          next if (!$avg->{fixed} and $upgradeable);
          next unless
            _compare($installed{$name}, $avg->{affected}) >= 0 and
            (!$avg->{fixed} or _compare($installed{$name}, $avg->{fixed}) == -1);

          $ctr_message .= "\t$avg->{severity}: $name is affected by $avg->{type} (" .
            join(' ', map { "https://security.archlinux.org/$_"  } @{$avg->{issues}}) .').';
          $ctr_message .= " Update to at least $avg->{fixed}" if $avg->{fixed};
          $ctr_message .= " No fix available:(" unless $avg->{fixed};
          $ctr_message .= "\n";
        }
      }
    }
    $report .= "$ctr\n$ctr_message" if $ctr_message;
  }
  $report
}

sub _split_ver { split /[.+:~-]/, lc(shift) || 0 }
sub _compare {
  my @v1 = _split_ver(shift);
  my @v2 = _split_ver(shift);

  my $last = $#v1 > $#v2 ? $#v1 : $#v2;
  for (0..$last) {
    push(@v1, 0) unless defined $v1[$_];
    push(@v2, 0) unless defined $v2[$_];

    if ($v1[$_] =~ /^\d+$/ and $v2[$_] =~ /^\d+$/) {
      return  1 if $v1[$_] > $v2[$_];
      return -1 if $v1[$_] < $v2[$_];
    } else {
      return  1 if $v1[$_] gt $v2[$_];
      return -1 if $v1[$_] lt $v2[$_];
    }
  }
  return 0;
}


my $ctrs = _installed_packages;
my $avgs = _get_vulns;

my $report = _generate_report($ctrs, $avgs);

if ($mail_to and $report) {
  # Create a new email message
  my $msg = MIME::Lite->new(
    From    => $mail_from || 'scanner',
    To      => $mail_to,
    Subject => 'Vulnerability Report',
    Data    => $report,
  );

  $msg->send('smtp', MAIL_SERVER);
  print "Email sent successfully\n";
} else {
  print $report;
}
