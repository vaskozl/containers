# Wolfi Base Images

## Introduction

This repository provides Wolfi based OCI/Docker containers which are built with consistency, minimalism, security and multi-architecture support in mind. The containers leverage both official packages and custom packages built with melange. Containers are versioned based on package versions, similar to official Docker images.

## Tagging Scheme

We follow a versioning scheme of upstream archlinux packages. For example `ghcr.io/vaskozl/kubectl:1.28.2-1` is available as:

* `ghcr.io/vaskozl/kubectl:latest`
* `ghcr.io/vaskozl/kubectl:1.28.2-1`
* `ghcr.io/vaskozl/kubectl:1.28.2`
* `ghcr.io/vaskozl/kubectl:1.28`
* `ghcr.io/vaskozl/kubectl:1`

You can choose the tag that best fits your needs, whether you want the latest version, a specific version, or even a particular release of a version. Do note that even releases pinned tags are not guarranteed to be immutable as the base is rebuilt weekly.

The best and intenteded way to achieve immutability is to just pin the images by by sha256 digest.

## Features

- **Multi-Arch Support**: These containers are built with support for `linux/amd64` and `linux/arm64`, thanks to the Arch Linux ARM project.

- **Renovate compatible**: Containers have the `org.opencontainers.image.source` label to facilitate changelog population.

- **Consistent Builds**: To ensure consistency and avoid partial upgrades, we build all containers [apko](https://github.com/chainguard-dev/apko). All files in the containers are packaged and compatible with security scanners.

- **Minimal Footprint**: The containers are designed to be minimal and lightweight, only what's need is included.

- **Versioned Images**: The container images are versioned based on the package versions, making it easy to pin your application to a specific version. This approach is similar to the way official Docker images are versioned.

- **Busybox included**: A minimal archlinux container has very few debugging tools installed, as such busybox is used to provide missing utils. Busybox utils are symliked in /opt/busybox/bin at the end of `$PATH` so GNU utils take presedence if installed, which you can easily do via pacman if needed!

## Usage

### Running the containers

The containers do not provide custom entrypoint scripts, and users are expected to provide
the command and arguments they desire.

In most cases that simply means running the program that is installed with the argument that you desire.

This helps keep everything simple and predictable and means you don't have to sift through a list environment variables just to figure out how to run the bespoke entrypoint. Configuration files can simply be mounted with volumes.
```bash
docker run -it ghcr.io/vaskozl/apk-tools bash
docker run -it -p 1883 ghcr.io/vaskozl/mosquitto:2.0.18 mosquitto
```

For more specific examples, check out [my manifests repository](https://github.com/vaskozl/home-infra).

| Image Name | Pull |
| ------------------------------------------------------------ | ---------------------------------------------------------------  |
| [thelounge](./thelounge.yaml)                                | `docker pull ghcr.io/vaskozl/thelounge`                          |
| [kubectl](./kubectl.yaml)                                    | `docker pull ghcr.io/vaskozl/kubectl`                            |
| [lidarr](./lidarr.yaml)                                      | `docker pull ghcr.io/vaskozl/lidarr`                             |
| [v2ray](./v2ray.yaml)                                        | `docker pull ghcr.io/vaskozl/v2ray`                              |
| [renovate](./renovate.yaml)                                  | `docker pull ghcr.io/vaskozl/renovate`                           |
| [rakudo](./rakudo.yaml)                                      | `docker pull ghcr.io/vaskozl/rakudo`                             |
| [prowlarr](./prowlarr.yaml)                                  | `docker pull ghcr.io/vaskozl/prowlarr`                           |
| [apk-tools](./apk-tools.yaml)                                | `docker pull ghcr.io/vaskozl/apk-tools`                          |
| [nfs-subdir-external-provisioner](./nfs-subdir-external-provisioner.yaml) | `docker pull ghcr.io/vaskozl/nfs-subdir-external-provisioner`    |
| [gitlab-runner](./gitlab/gitlab-runner.yaml)                 | `docker pull ghcr.io/vaskozl/gitlab-runner`                      |
| [gitlab-runner-helper](./gitlab/gitlab-runner-helper.yaml)   | `docker pull ghcr.io/vaskozl/gitlab-runner-helper`               |
| [gitlab-container-registry](./gitlab/gitlab-container-registry.yaml) | `docker pull ghcr.io/vaskozl/gitlab-container-registry`          |
| [gitlab-exporter](./gitlab/gitlab-exporter.yaml)             | `docker pull ghcr.io/vaskozl/gitlab-exporter`                    |
| [gitlab-shell](./gitlab/gitlab-shell.yaml)                   | `docker pull ghcr.io/vaskozl/gitlab-shell`                       |
| [gitlab-base](./gitlab/gitlab-base.yaml)                     | `docker pull ghcr.io/vaskozl/gitlab-base`                        |
| [gitaly](./gitlab/gitaly.yaml)                               | `docker pull ghcr.io/vaskozl/gitaly`                             |
| [gitlab-certificates](./gitlab/gitlab-certificates.yaml)     | `docker pull ghcr.io/vaskozl/gitlab-certificates`                |
| [gitlab-pages](./gitlab/gitlab-pages.yaml)                   | `docker pull ghcr.io/vaskozl/gitlab-pages`                       |
| [blocky](./blocky.yaml)                                      | `docker pull ghcr.io/vaskozl/blocky`                             |
| [anubis](./anubis.yaml)                                      | `docker pull ghcr.io/vaskozl/anubis`                             |
| [sonarr](./sonarr.yaml)                                      | `docker pull ghcr.io/vaskozl/sonarr`                             |
| [calibre](./calibre.yaml)                                    | `docker pull ghcr.io/vaskozl/calibre`                            |
| [wolfi](./wolfi.yaml)                                        | `docker pull ghcr.io/vaskozl/wolfi`                              |
| [apko](./apko.yaml)                                          | `docker pull ghcr.io/vaskozl/apko`                               |
| [hugo](./hugo.yaml)                                          | `docker pull ghcr.io/vaskozl/hugo`                               |
| [mosquitto](./mosquitto.yaml)                                | `docker pull ghcr.io/vaskozl/mosquitto`                          |
| [cert-manager-cainjector](./cert-manager/cert-manager-cainjector.yaml) | `docker pull ghcr.io/vaskozl/cert-manager-cainjector`            |
| [cert-manager-acmesolver](./cert-manager/cert-manager-acmesolver.yaml) | `docker pull ghcr.io/vaskozl/cert-manager-acmesolver`            |
| [cert-manager-webhook](./cert-manager/cert-manager-webhook.yaml) | `docker pull ghcr.io/vaskozl/cert-manager-webhook`               |
| [cert-manager-controller](./cert-manager/cert-manager-controller.yaml) | `docker pull ghcr.io/vaskozl/cert-manager-controller`            |
| [openresty](./openresty.yaml)                                | `docker pull ghcr.io/vaskozl/openresty`                          |
| [baikal](./baikal.yaml)                                      | `docker pull ghcr.io/vaskozl/baikal`                             |
| [go](./go.yaml)                                              | `docker pull ghcr.io/vaskozl/go`                                 |
| [perl-libwww](./perl-libwww.yaml)                            | `docker pull ghcr.io/vaskozl/perl-libwww`                        |
| [chromium](./chromium.yaml)                                  | `docker pull ghcr.io/vaskozl/chromium`                           |
| [ripgrep](./ripgrep.yaml)                                    | `docker pull ghcr.io/vaskozl/ripgrep`                            |
| [net-tools](./net-tools.yaml)                                | `docker pull ghcr.io/vaskozl/net-tools`                          |
| [radarr](./radarr.yaml)                                      | `docker pull ghcr.io/vaskozl/radarr`                             |
| [buildkitd](./buildkitd.yaml)                                | `docker pull ghcr.io/vaskozl/buildkitd`                          |
| [perl-mojolicious](./perl-mojolicious.yaml)                  | `docker pull ghcr.io/vaskozl/perl-mojolicious`                   |
| [nginx](./nginx.yaml)                                        | `docker pull ghcr.io/vaskozl/nginx`                              |
| [fluent-bit](./fluent-bit.yaml)                              | `docker pull ghcr.io/vaskozl/fluent-bit`                         |
| [docker](./docker.yaml)                                      | `docker pull ghcr.io/vaskozl/docker`                             |
| [qbittorrent-nox](./qbittorrent-nox.yaml)                    | `docker pull ghcr.io/vaskozl/qbittorrent-nox`                    |
| [grype](./grype.yaml)                                        | `docker pull ghcr.io/vaskozl/grype`                              |
| [git](./git.yaml)                                            | `docker pull ghcr.io/vaskozl/git`                                |
| [flannel](./flannel.yaml)                                    | `docker pull ghcr.io/vaskozl/flannel`                            |
| [logrotate](./logrotate.yaml)                                | `docker pull ghcr.io/vaskozl/logrotate`                          |
| [busybox](./busybox.yaml)                                    | `docker pull ghcr.io/vaskozl/busybox`                            |
| [ntfy](./ntfy.yaml)                                          | `docker pull ghcr.io/vaskozl/ntfy`                               |
| [melange](./melange.yaml)                                    | `docker pull ghcr.io/vaskozl/melange`                            |
| [postgresql](./postgresql.yaml)                              | `docker pull ghcr.io/vaskozl/postgresql`                         |
| [minio](./minio.yaml)                                        | `docker pull ghcr.io/vaskozl/minio`                              |
| [valkey](./valkey.yaml)                                      | `docker pull ghcr.io/vaskozl/valkey`                             |
| [redis](./redis.yaml)                                        | `docker pull ghcr.io/vaskozl/redis`                              |
| [mariadb](./mariadb.yaml)                                    | `docker pull ghcr.io/vaskozl/mariadb`                            |
| [maddy](./maddy.yaml)                                        | `docker pull ghcr.io/vaskozl/maddy`                              |
| [kubeconform](./kubeconform.yaml)                            | `docker pull ghcr.io/vaskozl/kubeconform`                        |
| [jellyfin](./jellyfin.yaml)                                  | `docker pull ghcr.io/vaskozl/jellyfin`                           |
| [tailscale-operator](./tailscale-operator.yaml)              | `docker pull ghcr.io/vaskozl/tailscale-operator`                 |
