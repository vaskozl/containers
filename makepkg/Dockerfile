FROM ghcr.io/vaskozl/archlinux:rolling@sha256:c27e4e7ae683474cd1c3a205a60960dc9ee2d4f4279306246c4d1a3c60d81229 AS makepkg

RUN --mount=type=cache,target=/var/cache/pacman/\
    pacman -S --noconfirm git base-devel sudo shadow

ARG USER=makepkg
RUN useradd --system --create-home $USER  && \
    echo "$USER ALL=(ALL:ALL) NOPASSWD:ALL" > /etc/sudoers.d/$USER

USER $USER
WORKDIR /home/$USER

ARG AURS
RUN --mount=type=cache,target=/var/cache/pacman/\
    for aur_pkg in "${AURS[@]}"; do \
        git clone https://aur.archlinux.org/${aur_pkg}.git && \
        cd $aur_pkg && \
        # Optimistically add aarch64 as an allowed architecture to build for
        sed -i "/^arch=/ { /\baarch64\b/! s/\(arch=([^)]*\))/\1 'aarch64')/ }" PKGBUILD && \
        makepkg -s --noconfirm && \
        cd ~; \
    done


FROM ghcr.io/vaskozl/archlinux:rolling@sha256:c27e4e7ae683474cd1c3a205a60960dc9ee2d4f4279306246c4d1a3c60d81229

ARG PKGS AURS
RUN --mount=type=bind,from=makepkg,source=/home/makepkg/,target=/mnt \
    if [ -z "$AURS" ] && [ -z "$PKGS" ]; then echo 'No AURS or PKGS'; exit 1; fi && \
    if [ -n "$AURS" ]; then pacman -U --noconfirm /mnt/*/*.pkg.tar.*; fi && \
    if [ -n "$PKGS" ]; then pacman -S --noconfirm $(echo $PKGS | tr ',' ' '); fi
