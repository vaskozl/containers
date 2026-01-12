# Wolfi Base Images

## Introduction

This repository provides Wolfi based OCI/Docker containers which are built with consistency, minimalism, security and multi-architecture support in mind. The containers leverage both official packages and custom packages built with melange. Containers are versioned based on package versions, similar to official Docker images.

## Features

- Distroless & Secure: Built from scratch using apko with a focus on security and small footprint.
- Continuous Updates: Regularly updated with the latest security patches.
- Multi-Arch Support: These containers are built with support for `linux/amd64` and `linux/arm64`.
- Renovate compatible: Containers have the `org.opencontainers.image.source` label to facilitate changelog population.
- Versioned Images: The container images are versioned based on the package versions, making it easy to pin your application to a specific version.
- Busybox included: Busybox is included for debugging and utility reasons in all images, while keeping them tiny.

## Tagging Scheme

We follow a versioning scheme of upstream wolfi packages. For example `ghcr.io/vaskozl/kubectl:1.28.2-1` is available as:

* `ghcr.io/vaskozl/kubectl:latest`
* `ghcr.io/vaskozl/kubectl:1.33.1`
* `ghcr.io/vaskozl/kubectl:1.33`
* `ghcr.io/vaskozl/kubectl:1`

You can choose the tag that best fits your needs, whether you want the latest version, a specific version, or even a particular release of a version. Do note that even releases pinned tags are **not** be immutable as they are rebuilt regularly to pick up the latest security fixes.

The best and intenteded way to achieve immutability is to just pin the images by by sha256 digest.

## Usage

### Running the containers

The containers do not provide custom entrypoint scripts, and users are expected to provide the command and arguments they desire. In most cases that simply means running the program that is installed with the argument that you desire. This helps keep everything simple and predictable and means you don't have to sift through a list environment variables just to figure out how to run the bespoke entrypoint. Configuration files can simply be mounted with volumes.

For more specific examples, check out [my manifests repository](https://github.com/vaskozl/home-infra).

| Image Name | Pull |
| ------------------------------------------------------------ | ---------------------------------------------------------------  |
| [anubis](./anubis.yaml)                                      | `docker pull ghcr.io/vaskozl/anubis`                             |
| [apk-tools](./apk-tools.yaml)                                | `docker pull ghcr.io/vaskozl/apk-tools`                          |
| [apko](./apko.yaml)                                          | `docker pull ghcr.io/vaskozl/apko`                               |
| [baikal](./baikal.yaml)                                      | `docker pull ghcr.io/vaskozl/baikal`                             |
| [blocky](./blocky.yaml)                                      | `docker pull ghcr.io/vaskozl/blocky`                             |
| [bootc](./bootc.yaml)                                        | `docker pull ghcr.io/vaskozl/bootc`                              |
| [buildkitd](./buildkitd.yaml)                                | `docker pull ghcr.io/vaskozl/buildkitd`                          |
| [cagebreak](./cagebreak.yaml)                                | `docker pull ghcr.io/vaskozl/cagebreak`                          |
| [calibre](./calibre.yaml)                                    | `docker pull ghcr.io/vaskozl/calibre`                            |
| [cert-manager-acmesolver](./cert-manager/cert-manager-acmesolver.yaml) | `docker pull ghcr.io/vaskozl/cert-manager-acmesolver`            |
| [cert-manager-cainjector](./cert-manager/cert-manager-cainjector.yaml) | `docker pull ghcr.io/vaskozl/cert-manager-cainjector`            |
| [cert-manager-controller](./cert-manager/cert-manager-controller.yaml) | `docker pull ghcr.io/vaskozl/cert-manager-controller`            |
| [cert-manager-webhook](./cert-manager/cert-manager-webhook.yaml) | `docker pull ghcr.io/vaskozl/cert-manager-webhook`               |
| [chromium](./chromium.yaml)                                  | `docker pull ghcr.io/vaskozl/chromium`                           |
| [code-server](./code-server.yaml)                            | `docker pull ghcr.io/vaskozl/code-server`                        |
| [docker](./docker.yaml)                                      | `docker pull ghcr.io/vaskozl/docker`                             |
| [flannel](./flannel.yaml)                                    | `docker pull ghcr.io/vaskozl/flannel`                            |
| [fluent-bit](./fluent-bit.yaml)                              | `docker pull ghcr.io/vaskozl/fluent-bit`                         |
| [git](./git.yaml)                                            | `docker pull ghcr.io/vaskozl/git`                                |
| [gitaly](./gitlab/gitaly.yaml)                               | `docker pull ghcr.io/vaskozl/gitaly`                             |
| [gitlab-pages](./gitlab/gitlab-pages.yaml)                   | `docker pull ghcr.io/vaskozl/gitlab-pages`                       |
| [gitlab-runner-helper](./gitlab/gitlab-runner-helper.yaml)   | `docker pull ghcr.io/vaskozl/gitlab-runner-helper`               |
| [gitlab-runner](./gitlab/gitlab-runner.yaml)                 | `docker pull ghcr.io/vaskozl/gitlab-runner`                      |
| [go](./go.yaml)                                              | `docker pull ghcr.io/vaskozl/go`                                 |
| [golink](./golink.yaml)                                      | `docker pull ghcr.io/vaskozl/golink`                             |
| [grafana](./grafana.yaml)                                    | `docker pull ghcr.io/vaskozl/grafana`                            |
| [grype](./grype.yaml)                                        | `docker pull ghcr.io/vaskozl/grype`                              |
| [haproxy](./haproxy.yaml)                                    | `docker pull ghcr.io/vaskozl/haproxy`                            |
| [hugo](./hugo.yaml)                                          | `docker pull ghcr.io/vaskozl/hugo`                               |
| [jellyfin](./jellyfin.yaml)                                  | `docker pull ghcr.io/vaskozl/jellyfin`                           |
| [k8s-sidecar](./k8s-sidecar.yaml)                            | `docker pull ghcr.io/vaskozl/k8s-sidecar`                        |
| [kromgo](./kromgo.yaml)                                      | `docker pull ghcr.io/vaskozl/kromgo`                             |
| [kube-ip-tracker](./kube-ip-tracker.yaml)                    | `docker pull ghcr.io/vaskozl/kube-ip-tracker`                    |
| [kube-network-policies](./kube-network-policies.yaml)        | `docker pull ghcr.io/vaskozl/kube-network-policies`              |
| [kubeconform](./kubeconform.yaml)                            | `docker pull ghcr.io/vaskozl/kubeconform`                        |
| [kubectl](./kubectl.yaml)                                    | `docker pull ghcr.io/vaskozl/kubectl`                            |
| [kubelet](./kubelet.yaml)                                    | `docker pull ghcr.io/vaskozl/kubelet`                            |
| [lidarr](./lidarr.yaml)                                      | `docker pull ghcr.io/vaskozl/lidarr`                             |
| [logrotate](./logrotate.yaml)                                | `docker pull ghcr.io/vaskozl/logrotate`                          |
| [maddy](./maddy.yaml)                                        | `docker pull ghcr.io/vaskozl/maddy`                              |
| [mariadb](./mariadb.yaml)                                    | `docker pull ghcr.io/vaskozl/mariadb`                            |
| [melange](./melange.yaml)                                    | `docker pull ghcr.io/vaskozl/melange`                            |
| [minilb](./minilb.yaml)                                      | `docker pull ghcr.io/vaskozl/minilb`                             |
| [minio](./minio.yaml)                                        | `docker pull ghcr.io/vaskozl/minio`                              |
| [mosquitto](./mosquitto.yaml)                                | `docker pull ghcr.io/vaskozl/mosquitto`                          |
| [net-tools](./net-tools.yaml)                                | `docker pull ghcr.io/vaskozl/net-tools`                          |
| [nfs-subdir-external-provisioner](./nfs-subdir-external-provisioner.yaml) | `docker pull ghcr.io/vaskozl/nfs-subdir-external-provisioner`    |
| [nginx](./nginx.yaml)                                        | `docker pull ghcr.io/vaskozl/nginx`                              |
| [ntfy](./ntfy.yaml)                                          | `docker pull ghcr.io/vaskozl/ntfy`                               |
| [oauth2-proxy](./oauth2-proxy.yaml)                          | `docker pull ghcr.io/vaskozl/oauth2-proxy`                       |
| [openresty](./openresty.yaml)                                | `docker pull ghcr.io/vaskozl/openresty`                          |
| [perl-libwww](./perl-libwww.yaml)                            | `docker pull ghcr.io/vaskozl/perl-libwww`                        |
| [perl-mojolicious](./perl-mojolicious.yaml)                  | `docker pull ghcr.io/vaskozl/perl-mojolicious`                   |
| [pinewall-config](./pinewall-config.yaml)                    | `docker pull ghcr.io/vaskozl/pinewall-config`                    |
| [postgresql](./postgresql.yaml)                              | `docker pull ghcr.io/vaskozl/postgresql`                         |
| [prometheus-alertmanager](./prometheus-alertmanager.yaml)    | `docker pull ghcr.io/vaskozl/prometheus-alertmanager`            |
| [prowlarr](./prowlarr.yaml)                                  | `docker pull ghcr.io/vaskozl/prowlarr`                           |
| [qbittorrent-nox](./qbittorrent-nox.yaml)                    | `docker pull ghcr.io/vaskozl/qbittorrent-nox`                    |
| [radarr](./radarr.yaml)                                      | `docker pull ghcr.io/vaskozl/radarr`                             |
| [rakudo](./rakudo.yaml)                                      | `docker pull ghcr.io/vaskozl/rakudo`                             |
| [redis](./redis.yaml)                                        | `docker pull ghcr.io/vaskozl/redis`                              |
| [renovate-apk-indexer](./renovate-apk-indexer.yaml)          | `docker pull ghcr.io/vaskozl/renovate-apk-indexer`               |
| [renovate](./renovate.yaml)                                  | `docker pull ghcr.io/vaskozl/renovate`                           |
| [ripgrep](./ripgrep.yaml)                                    | `docker pull ghcr.io/vaskozl/ripgrep`                            |
| [sonarr](./sonarr.yaml)                                      | `docker pull ghcr.io/vaskozl/sonarr`                             |
| [synology-csi](./synology-csi.yaml)                          | `docker pull ghcr.io/vaskozl/synology-csi`                       |
| [tailscale-operator](./tailscale-operator.yaml)              | `docker pull ghcr.io/vaskozl/tailscale-operator`                 |
| [tailscale](./tailscale.yaml)                                | `docker pull ghcr.io/vaskozl/tailscale`                          |
| [thelounge](./thelounge.yaml)                                | `docker pull ghcr.io/vaskozl/thelounge`                          |
| [tsidp](./tsidp.yaml)                                        | `docker pull ghcr.io/vaskozl/tsidp`                              |
| [v2ray](./v2ray.yaml)                                        | `docker pull ghcr.io/vaskozl/v2ray`                              |
| [valkey](./valkey.yaml)                                      | `docker pull ghcr.io/vaskozl/valkey`                             |
| [wolfi-scanner](./wolfi-scanner.yaml)                        | `docker pull ghcr.io/vaskozl/wolfi-scanner`                      |
| [wolfictl](./wolfictl.yaml)                                  | `docker pull ghcr.io/vaskozl/wolfictl`                           |
