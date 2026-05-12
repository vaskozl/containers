# apkontainers

[Wolfi](https://github.com/wolfi-dev) is a rolling-release Linux undistro: Alpine's packaging conventions, `glibc` instead of `musl`, no kernel. [Chainguard Containers](https://edu.chainguard.dev/chainguard/chainguard-images/overview/) are built on it. This repo is the same idea but for things Chainguard doesn't ship, plus a few opinions of my own.

Every image is a declarative [`apko`](https://github.com/chainguard-dev/apko) YAML. No `RUN curl $DODGY_URL | sh`, no layer cache busting, no recompiling the world when the base changes. The build is reproducible and every file in the image is owned by an APK with a version, a license, and a recipe you can read.

Two properties fall out of this for free:

- **Composability.** Bump one package, rebuild one layer. Nothing else recompiles.
- **Accountability.** Every file lives in `/usr/bin`, `/usr/lib`, `/etc` — not `/app/` or whatever cursed directory the upstream `Dockerfile` invented.

Custom packages that aren't in Wolfi yet are built with [`melange`](https://github.com/chainguard-dev/melange) and live in [`packages/`](./packages/). Built APKs are published to `https://apks.sko.ai`.

A subset — `bootc`, `containerd`, `niri`, `cagebreak`, `pinewall-config` — are also bootable hosts via [`bootc`](https://bootc-dev.github.io/bootc/). For how the pieces fit together, see [Making Bootable Wolfi Containers](https://sko.ai/blog/making-bootable-wolfi-containers/).

## Tagging

Tags follow the upstream Wolfi package version. `ghcr.io/vaskozl/kubectl:1.33.1-r0` is also available as:

- `ghcr.io/vaskozl/kubectl:1.33.1`
- `ghcr.io/vaskozl/kubectl:1.33`
- `ghcr.io/vaskozl/kubectl:1`
- `ghcr.io/vaskozl/kubectl:latest`

Even pinned tags are rebuilt nightly to pick up security fixes, so they're not immutable. Pin by digest if you need that guarantee.

[Renovate](https://github.com/renovatebot/renovate) keeps the `=version` pins in the YAML files fresh via a custom [`renovate-apk-indexer`](https://github.com/hown3d/renovate-apk-indexer) datasource that reads `APKINDEX.tar.gz`.

## Usage

Images have no custom entrypoint scripts. Pass the command and arguments directly. Configuration goes in via volume mounts. For real-world examples see [`vaskozl/home-infra`](https://github.com/vaskozl/home-infra).

## Images

| Image | Pull |
| --- | --- |
| [anubis](./anubis.yaml) | [`ghcr.io/vaskozl/anubis`](https://github.com/vaskozl/containers/pkgs/container/anubis) |
| [apk-tools](./apk-tools.yaml) | [`ghcr.io/vaskozl/apk-tools`](https://github.com/vaskozl/containers/pkgs/container/apk-tools) |
| [apko](./apko.yaml) | [`ghcr.io/vaskozl/apko`](https://github.com/vaskozl/containers/pkgs/container/apko) |
| [baikal](./baikal.yaml) | [`ghcr.io/vaskozl/baikal`](https://github.com/vaskozl/containers/pkgs/container/baikal) |
| [blocky](./blocky.yaml) | [`ghcr.io/vaskozl/blocky`](https://github.com/vaskozl/containers/pkgs/container/blocky) |
| [bootc](./bootc.yaml) | [`ghcr.io/vaskozl/bootc`](https://github.com/vaskozl/containers/pkgs/container/bootc) |
| [brew](./brew.yaml) | [`ghcr.io/vaskozl/brew`](https://github.com/vaskozl/containers/pkgs/container/brew) |
| [buildkitd](./buildkitd.yaml) | [`ghcr.io/vaskozl/buildkitd`](https://github.com/vaskozl/containers/pkgs/container/buildkitd) |
| [cagebreak](./cagebreak.yaml) | [`ghcr.io/vaskozl/cagebreak`](https://github.com/vaskozl/containers/pkgs/container/cagebreak) |
| [calibre](./calibre.yaml) | [`ghcr.io/vaskozl/calibre`](https://github.com/vaskozl/containers/pkgs/container/calibre) |
| [cert-manager-acmesolver](./cert-manager/cert-manager-acmesolver.yaml) | [`ghcr.io/vaskozl/cert-manager-acmesolver`](https://github.com/vaskozl/containers/pkgs/container/cert-manager-acmesolver) |
| [cert-manager-cainjector](./cert-manager/cert-manager-cainjector.yaml) | [`ghcr.io/vaskozl/cert-manager-cainjector`](https://github.com/vaskozl/containers/pkgs/container/cert-manager-cainjector) |
| [cert-manager-controller](./cert-manager/cert-manager-controller.yaml) | [`ghcr.io/vaskozl/cert-manager-controller`](https://github.com/vaskozl/containers/pkgs/container/cert-manager-controller) |
| [cert-manager-webhook](./cert-manager/cert-manager-webhook.yaml) | [`ghcr.io/vaskozl/cert-manager-webhook`](https://github.com/vaskozl/containers/pkgs/container/cert-manager-webhook) |
| [chromium](./chromium.yaml) | [`ghcr.io/vaskozl/chromium`](https://github.com/vaskozl/containers/pkgs/container/chromium) |
| [claude](./claude.yaml) | [`ghcr.io/vaskozl/claude`](https://github.com/vaskozl/containers/pkgs/container/claude) |
| [cloudflared](./cloudflared.yaml) | [`ghcr.io/vaskozl/cloudflared`](https://github.com/vaskozl/containers/pkgs/container/cloudflared) |
| [code-server](./code-server.yaml) | [`ghcr.io/vaskozl/code-server`](https://github.com/vaskozl/containers/pkgs/container/code-server) |
| [containerd](./containerd.yaml) | [`ghcr.io/vaskozl/containerd`](https://github.com/vaskozl/containers/pkgs/container/containerd) |
| [coredns](./coredns.yaml) | [`ghcr.io/vaskozl/coredns`](https://github.com/vaskozl/containers/pkgs/container/coredns) |
| [docker](./docker.yaml) | [`ghcr.io/vaskozl/docker`](https://github.com/vaskozl/containers/pkgs/container/docker) |
| [flannel](./flannel.yaml) | [`ghcr.io/vaskozl/flannel`](https://github.com/vaskozl/containers/pkgs/container/flannel) |
| [fluent-bit](./fluent-bit.yaml) | [`ghcr.io/vaskozl/fluent-bit`](https://github.com/vaskozl/containers/pkgs/container/fluent-bit) |
| [git](./git.yaml) | [`ghcr.io/vaskozl/git`](https://github.com/vaskozl/containers/pkgs/container/git) |
| [gitlab-runner-helper](./gitlab/gitlab-runner-helper.yaml) | [`ghcr.io/vaskozl/gitlab-runner-helper`](https://github.com/vaskozl/containers/pkgs/container/gitlab-runner-helper) |
| [gitlab-runner](./gitlab/gitlab-runner.yaml) | [`ghcr.io/vaskozl/gitlab-runner`](https://github.com/vaskozl/containers/pkgs/container/gitlab-runner) |
| [go](./go.yaml) | [`ghcr.io/vaskozl/go`](https://github.com/vaskozl/containers/pkgs/container/go) |
| [golink](./golink.yaml) | [`ghcr.io/vaskozl/golink`](https://github.com/vaskozl/containers/pkgs/container/golink) |
| [grafana](./grafana.yaml) | [`ghcr.io/vaskozl/grafana`](https://github.com/vaskozl/containers/pkgs/container/grafana) |
| [grype](./grype.yaml) | [`ghcr.io/vaskozl/grype`](https://github.com/vaskozl/containers/pkgs/container/grype) |
| [haproxy](./haproxy.yaml) | [`ghcr.io/vaskozl/haproxy`](https://github.com/vaskozl/containers/pkgs/container/haproxy) |
| [hugo](./hugo.yaml) | [`ghcr.io/vaskozl/hugo`](https://github.com/vaskozl/containers/pkgs/container/hugo) |
| [jellyfin](./jellyfin.yaml) | [`ghcr.io/vaskozl/jellyfin`](https://github.com/vaskozl/containers/pkgs/container/jellyfin) |
| [k8s-sidecar](./k8s-sidecar.yaml) | [`ghcr.io/vaskozl/k8s-sidecar`](https://github.com/vaskozl/containers/pkgs/container/k8s-sidecar) |
| [kromgo](./kromgo.yaml) | [`ghcr.io/vaskozl/kromgo`](https://github.com/vaskozl/containers/pkgs/container/kromgo) |
| [kube-ip-tracker](./kube-ip-tracker.yaml) | [`ghcr.io/vaskozl/kube-ip-tracker`](https://github.com/vaskozl/containers/pkgs/container/kube-ip-tracker) |
| [kube-network-policies](./kube-network-policies.yaml) | [`ghcr.io/vaskozl/kube-network-policies`](https://github.com/vaskozl/containers/pkgs/container/kube-network-policies) |
| [kubeconform](./kubeconform.yaml) | [`ghcr.io/vaskozl/kubeconform`](https://github.com/vaskozl/containers/pkgs/container/kubeconform) |
| [kubectl](./kubectl.yaml) | [`ghcr.io/vaskozl/kubectl`](https://github.com/vaskozl/containers/pkgs/container/kubectl) |
| [kubelet](./kubelet.yaml) | [`ghcr.io/vaskozl/kubelet`](https://github.com/vaskozl/containers/pkgs/container/kubelet) |
| [lidarr](./lidarr.yaml) | [`ghcr.io/vaskozl/lidarr`](https://github.com/vaskozl/containers/pkgs/container/lidarr) |
| [logrotate](./logrotate.yaml) | [`ghcr.io/vaskozl/logrotate`](https://github.com/vaskozl/containers/pkgs/container/logrotate) |
| [maddy](./maddy.yaml) | [`ghcr.io/vaskozl/maddy`](https://github.com/vaskozl/containers/pkgs/container/maddy) |
| [mariadb](./mariadb.yaml) | [`ghcr.io/vaskozl/mariadb`](https://github.com/vaskozl/containers/pkgs/container/mariadb) |
| [melange](./melange.yaml) | [`ghcr.io/vaskozl/melange`](https://github.com/vaskozl/containers/pkgs/container/melange) |
| [minilb](./minilb.yaml) | [`ghcr.io/vaskozl/minilb`](https://github.com/vaskozl/containers/pkgs/container/minilb) |
| [minio](./minio.yaml) | [`ghcr.io/vaskozl/minio`](https://github.com/vaskozl/containers/pkgs/container/minio) |
| [mosquitto](./mosquitto.yaml) | [`ghcr.io/vaskozl/mosquitto`](https://github.com/vaskozl/containers/pkgs/container/mosquitto) |
| [net-tools](./net-tools.yaml) | [`ghcr.io/vaskozl/net-tools`](https://github.com/vaskozl/containers/pkgs/container/net-tools) |
| [nfs-subdir-external-provisioner](./nfs-subdir-external-provisioner.yaml) | [`ghcr.io/vaskozl/nfs-subdir-external-provisioner`](https://github.com/vaskozl/containers/pkgs/container/nfs-subdir-external-provisioner) |
| [nginx](./nginx.yaml) | [`ghcr.io/vaskozl/nginx`](https://github.com/vaskozl/containers/pkgs/container/nginx) |
| [niri](./niri.yaml) | [`ghcr.io/vaskozl/niri`](https://github.com/vaskozl/containers/pkgs/container/niri) |
| [ntfy](./ntfy.yaml) | [`ghcr.io/vaskozl/ntfy`](https://github.com/vaskozl/containers/pkgs/container/ntfy) |
| [oauth2-proxy](./oauth2-proxy.yaml) | [`ghcr.io/vaskozl/oauth2-proxy`](https://github.com/vaskozl/containers/pkgs/container/oauth2-proxy) |
| [openresty](./openresty.yaml) | [`ghcr.io/vaskozl/openresty`](https://github.com/vaskozl/containers/pkgs/container/openresty) |
| [perl-libwww](./perl-libwww.yaml) | [`ghcr.io/vaskozl/perl-libwww`](https://github.com/vaskozl/containers/pkgs/container/perl-libwww) |
| [perl-mojolicious](./perl-mojolicious.yaml) | [`ghcr.io/vaskozl/perl-mojolicious`](https://github.com/vaskozl/containers/pkgs/container/perl-mojolicious) |
| [pinewall-config](./pinewall-config.yaml) | [`ghcr.io/vaskozl/pinewall-config`](https://github.com/vaskozl/containers/pkgs/container/pinewall-config) |
| [postgresql](./postgresql.yaml) | [`ghcr.io/vaskozl/postgresql`](https://github.com/vaskozl/containers/pkgs/container/postgresql) |
| [prometheus-alertmanager](./prometheus-alertmanager.yaml) | [`ghcr.io/vaskozl/prometheus-alertmanager`](https://github.com/vaskozl/containers/pkgs/container/prometheus-alertmanager) |
| [prometheus-node-exporter](./prometheus-node-exporter.yaml) | [`ghcr.io/vaskozl/prometheus-node-exporter`](https://github.com/vaskozl/containers/pkgs/container/prometheus-node-exporter) |
| [prowlarr](./prowlarr.yaml) | [`ghcr.io/vaskozl/prowlarr`](https://github.com/vaskozl/containers/pkgs/container/prowlarr) |
| [qbittorrent-nox](./qbittorrent-nox.yaml) | [`ghcr.io/vaskozl/qbittorrent-nox`](https://github.com/vaskozl/containers/pkgs/container/qbittorrent-nox) |
| [radarr](./radarr.yaml) | [`ghcr.io/vaskozl/radarr`](https://github.com/vaskozl/containers/pkgs/container/radarr) |
| [rakudo](./rakudo.yaml) | [`ghcr.io/vaskozl/rakudo`](https://github.com/vaskozl/containers/pkgs/container/rakudo) |
| [redis](./redis.yaml) | [`ghcr.io/vaskozl/redis`](https://github.com/vaskozl/containers/pkgs/container/redis) |
| [renovate-apk-indexer](./renovate-apk-indexer.yaml) | [`ghcr.io/vaskozl/renovate-apk-indexer`](https://github.com/vaskozl/containers/pkgs/container/renovate-apk-indexer) |
| [renovate](./renovate.yaml) | [`ghcr.io/vaskozl/renovate`](https://github.com/vaskozl/containers/pkgs/container/renovate) |
| [rest-server](./rest-server.yaml) | [`ghcr.io/vaskozl/rest-server`](https://github.com/vaskozl/containers/pkgs/container/rest-server) |
| [restic](./restic.yaml) | [`ghcr.io/vaskozl/restic`](https://github.com/vaskozl/containers/pkgs/container/restic) |
| [ripgrep](./ripgrep.yaml) | [`ghcr.io/vaskozl/ripgrep`](https://github.com/vaskozl/containers/pkgs/container/ripgrep) |
| [rust](./rust.yaml) | [`ghcr.io/vaskozl/rust`](https://github.com/vaskozl/containers/pkgs/container/rust) |
| [sing-box](./sing-box.yaml) | [`ghcr.io/vaskozl/sing-box`](https://github.com/vaskozl/containers/pkgs/container/sing-box) |
| [sonarr](./sonarr.yaml) | [`ghcr.io/vaskozl/sonarr`](https://github.com/vaskozl/containers/pkgs/container/sonarr) |
| [syncthing](./syncthing.yaml) | [`ghcr.io/vaskozl/syncthing`](https://github.com/vaskozl/containers/pkgs/container/syncthing) |
| [synology-csi](./synology-csi.yaml) | [`ghcr.io/vaskozl/synology-csi`](https://github.com/vaskozl/containers/pkgs/container/synology-csi) |
| [tailscale-operator](./tailscale-operator.yaml) | [`ghcr.io/vaskozl/tailscale-operator`](https://github.com/vaskozl/containers/pkgs/container/tailscale-operator) |
| [tailscale](./tailscale.yaml) | [`ghcr.io/vaskozl/tailscale`](https://github.com/vaskozl/containers/pkgs/container/tailscale) |
| [thelounge](./thelounge.yaml) | [`ghcr.io/vaskozl/thelounge`](https://github.com/vaskozl/containers/pkgs/container/thelounge) |
| [trusttunnel](./trusttunnel.yaml) | [`ghcr.io/vaskozl/trusttunnel`](https://github.com/vaskozl/containers/pkgs/container/trusttunnel) |
| [tsidp](./tsidp.yaml) | [`ghcr.io/vaskozl/tsidp`](https://github.com/vaskozl/containers/pkgs/container/tsidp) |
| [v2ray](./v2ray.yaml) | [`ghcr.io/vaskozl/v2ray`](https://github.com/vaskozl/containers/pkgs/container/v2ray) |
| [valkey](./valkey.yaml) | [`ghcr.io/vaskozl/valkey`](https://github.com/vaskozl/containers/pkgs/container/valkey) |
| [wolfi-scanner](./wolfi-scanner.yaml) | [`ghcr.io/vaskozl/wolfi-scanner`](https://github.com/vaskozl/containers/pkgs/container/wolfi-scanner) |
| [wolfictl](./wolfictl.yaml) | [`ghcr.io/vaskozl/wolfictl`](https://github.com/vaskozl/containers/pkgs/container/wolfictl) |
## Related

- Packages (`melange` recipes, APK registry): [`packages/`](./packages/)
- Home infra manifests: [`vaskozl/home-infra`](https://github.com/vaskozl/home-infra)
- Router config: [`vaskozl/pinewall-config`](https://github.com/vaskozl/pinewall-config)
