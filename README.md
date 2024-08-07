# Arch Linux Containers

## Introduction

This repository provides Arch-Linux based OCI/Docker containers which are built with consistency, minimalism, security and multi-architecture support in mind. The containers leverage both official packages and packages from the Arch User Repository (AUR). Containers are versioned based on package versions, similar to official Docker images.

## Tagging Scheme

We follow a versioning scheme of upstream archlinux packages. For example `ghcr.io/vaskozl/kubectl:1.28.2-1` is available as:

* `ghcr.io/vaskozl/kubectl:latest`
* `ghcr.io/vaskozl/kubectl:1.28.2-1`
* `ghcr.io/vaskozl/kubectl:1.28.2`
* `ghcr.io/vaskozl/kubectl:1.28`
* `ghcr.io/vaskozl/kubectl:1`

You can choose the tag that best fits your needs, whether you want the latest version, a specific version, or even a particular release of a version. Do note that even releases pinned tags are not guarranteed to be immutable as the base is rebuilt weekly.

The best and intenteded way to achieve immutability is to just pin the images by by sha256.

## Features

- **Multi-Arch Support**: These containers are built with support for `linux/amd64` and `linux/arm64`, thanks to the Arch Linux ARM project.

- **Renovate compatible**: Containers have the `org.opencontainers.image.source` label to facilitate changelog population.

- **Consistent Builds**: To ensure consistency and avoid partial upgrades, we build all containers from a common base `ghcr.io/vaskozl/archlinux:rolling` weekly and do not strip the package database. This ensures that all packages in the container are built against the same libraries. Furthermore package database is left in the final images such that pacman can be used reliably in the container or if the image is used as a base. This is in line with [arch wiki best practices](https://wiki.archlinux.org/title/system_maintenance#Partial_upgrades_are_unsupported).

- **Minimal Footprint**: The containers are designed to be minimal and lightweight, only including a subset of `base`. This helps reduce the attack surface and minimize resource usage.

- **Versioned Images**: The container images are versioned based on the package versions, making it easy to pin your application to a specific version. This approach is similar to the way official Docker images are versioned.

- **Busybox included**: A minimal archlinux container has very few debugging tools installed, as such busybox is used to provide missing utils. Busybox utils are symliked in /opt/busybox/bin at the end of `$PATH` so GNU utils take presedence if installed, which you can easily do via pacman if needed!

- **Official and AUR Packages**: We provide a blend of containers utilising official packages from the Arch Linux repositories and community-contributed packages from the AUR.

- **Common base**: All images are built with the same common archlinux base. If you use multiple images the base layer will be shared - they will take up less disk space and pull faster than a mixture of images which do not share the same base. Furthermore the common archlinux base featuring `pacman` makes debugging that much easier and more consistent.

- **`catatonit` included**: Images come with [catatonit](https://github.com/openSUSE/catatonit) set as the default entrypoint. Catatonit will ensure that forks of processes are correctly reaped, while also properly passing down termination signals.

## Usage

### Running the containers

The containers do not provide custom entrypoint scripts, and users are expected to provide
the command and arguments they desire.

In most cases that simply means running the program that is installed with the argument that you desire.

This helps keep everything simple and predictable and means you don't have to sift through a list environment variables just to figure out how to run the bespoke entrypoint. Configuration files can simply be mounted with volumes.
```bash
docker run -it ghcr.io/vaskozl/archlinux bash
docker run -it -p 1883 ghcr.io/vaskozl/mosquitto:2.0.18 mosquitto
```

For more specific examples, check out [my manifests repository](https://github.com/vaskozl/home-infra).

### Building a custom container

For example if you wanted to build znc including `znc` and `znc-clientbuffer` from the official repos and `znc-push-git` from the AUR you can set the `PKGS` and `AURS` env vars, with the required packages seperated by commas.

```bash
# Build a fresh base image first in order to have an up to date package db
docker buildx build -t ghcr.io/vaskozl/archlinux:rolling archlinux
# Include whatever packages you want!
docker buildx build . --build-arg="PKGS=znc,znc-clientbuffer" --build-arg="AURS=znc-push-git" -t znc -f makepkg/Dockerfile
```

## License

This project is licensed under the MIT License.

## Acknowledgments

This project would not be possible without the efforts and support of the Arch Linux and Arch Linux ARM communities and all the maintainers which make this possible. We extend our thanks to them for making Arch Linux available and accessible on a variety of architectures.

Credit to [lopsided98 repo](https://github.com/lopsided98/archlinux-docker) which provided inspiration for the base build.

---

*Disclaimer: This project is not officially affiliated with the Arch Linux project or the Arch Linux ARM project. It is a community-driven effort to provide consistent multiarch Arch Linux containers.*
