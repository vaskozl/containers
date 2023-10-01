FROM ghcr.io/vaskozl/archlinux:rolling@sha256:c8fee0599ddf050b8ae38c64333f9b06555403c97d06e45ae594cbc3f1b42d61 AS makepkg

RUN --mount=type=cache,target=/var/cache/pacman/\
    pacman -S --noconfirm git base-devel sudo shadow

ARG USER=makepkg
RUN useradd --system --create-home $USER  && \
    echo "$USER ALL=(ALL:ALL) NOPASSWD:ALL" > /etc/sudoers.d/$USER

USER $USER
WORKDIR /home/$USER

ARG AURS
# Loop twice sync deps with pacman cache first time and build the second time around
RUN --mount=type=cache,sharing=locked,target=/var/cache/pacman/\
    for aur_pkg in tini "${AURS[@]}"; do \
        git clone --depth=1 https://aur.archlinux.org/${aur_pkg}.git && \
        cd ~/$aur_pkg && \
        # Optimistically add aarch64 as an allowed architecture to build for
        sed -i "/^arch=/ { /\bany\b/! { /\baarch64\b/! s/\(arch=([^)]*\))/\1 'aarch64')/ }}" PKGBUILD && \
        makepkg --syncdeps --nobuild --noconfirm && \
        cd ~; \
    done

RUN \
    for aur_pkg in tini "${AURS[@]}"; do \
        cd ~/$aur_pkg && makepkg --noconfirm; \
    done

FROM ghcr.io/vaskozl/archlinux:rolling@sha256:c8fee0599ddf050b8ae38c64333f9b06555403c97d06e45ae594cbc3f1b42d61

ARG PKGS AURS
RUN --mount=type=bind,from=makepkg,source=/home/makepkg/,target=/mnt \
    --mount=type=cache,sharing=locked,target=/var/cache/pacman/\
    if [ -z "$AURS" ] && [ -z "$PKGS" ]; then echo 'No AURS or PKGS'; exit 1; fi && \
    pacman -U --noconfirm /mnt/*/*.pkg.tar.* && \
    if [ -n "$PKGS" ]; then pacman -S --noconfirm $(echo $PKGS | tr ',' ' '); fi

ENTRYPOINT ["/usr/bin/tini", "--"]
