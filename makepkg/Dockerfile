FROM ghcr.io/vaskozl/archlinux:rolling@sha256:fdf06404c9e58a612e6d1d3ac082d070c9efabddf1b867eb8c163571cbae849b AS makepkg

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
    for aur_pkg in "${AURS[@]}"; do \
        git clone --depth=1 https://aur.archlinux.org/${aur_pkg}.git && \
        cd ~/$aur_pkg && \
        # Optimistically add aarch64 as an allowed architecture to build for
        sed -i "/^arch=/ { /\bany\b/! { /\baarch64\b/! s/\(arch=([^)]*\))/\1 'aarch64')/ }}" PKGBUILD && \
        makepkg --syncdeps --nobuild --noconfirm && \
        cd ~; \
    done

RUN \
    for aur_pkg in "${AURS[@]}"; do \
        cd ~/$aur_pkg && makepkg --noconfirm; \
    done

FROM ghcr.io/vaskozl/archlinux:rolling@sha256:fdf06404c9e58a612e6d1d3ac082d070c9efabddf1b867eb8c163571cbae849b

ARG PKGS AURS EXP_PKG EXP_VER
RUN --mount=type=bind,from=makepkg,source=/home/makepkg/,target=/mnt \
    --mount=type=cache,sharing=locked,target=/var/cache/pacman/\
    if [ -z "$AURS" ] && [ -z "$PKGS" ]; then echo 'No AURS or PKGS'; exit 1; fi && \
    pacman -U --noconfirm /mnt/*/*.pkg.tar.* && \
    if [ -n "$PKGS" ]; then pacman -S --noconfirm $(echo $PKGS | tr ',' ' '); fi && \
    if ! pacman -Q $EXP_PKG | grep "$EXP_VER"; then \
        pacman -Q && echo "Expected $EXP_VER but got $(pacman -Q $EXP_PKG)" && exit 1; \
    fi
