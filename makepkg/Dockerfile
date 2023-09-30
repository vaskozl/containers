FROM ghcr.io/vaskozl/archlinux:rolling@sha256:eccfb5416f2e4dc2b4d1aceeace77eee6d12ac17fc73c469c6a1026dd6ec5b4f AS makepkg

RUN --mount=type=cache,target=/var/cache/pacman/\
    pacman -Sy --noconfirm git base-devel sudo shadow

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
        makepkg -s --noconfirm && \
        cd ~; \
    done


FROM ghcr.io/vaskozl/archlinux:rolling@sha256:eccfb5416f2e4dc2b4d1aceeace77eee6d12ac17fc73c469c6a1026dd6ec5b4f

ARG PKGS AURS
RUN --mount=type=bind,from=makepkg,source=/home/makepkg/,target=/mnt \
    pacman -Sy && \
    if [ -n "$AURS" ]; then pacman -U --noconfirm /mnt/*/*.pkg.tar.*; fi && \
    if [ -n "$PKGS" ]; then pacman -S --noconfirm $(echo $PKGS | tr ',' ' ');fi
