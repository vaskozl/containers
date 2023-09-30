FROM ghcr.io/vaskozl/archlinux:rolling@sha256:eccfb5416f2e4dc2b4d1aceeace77eee6d12ac17fc73c469c6a1026dd6ec5b4f AS makepkg

RUN --mount=type=cache,target=/var/cache/pacman/\
    pacman -Sy --noconfirm git base-devel sudo shadow

ARG USER=makepkg
RUN useradd --system --create-home $USER  && \
    echo "$USER ALL=(ALL:ALL) NOPASSWD:ALL" > /etc/sudoers.d/$USER

USER $USER
WORKDIR /home/$USER

ARG PACKAGE
RUN --mount=type=cache,target=/var/cache/pacman/\
    git clone https://aur.archlinux.org/$PACKAGE.git && \
    cd $PACKAGE && \
    makepkg -s --noconfirm


FROM ghcr.io/vaskozl/archlinux:rolling@sha256:eccfb5416f2e4dc2b4d1aceeace77eee6d12ac17fc73c469c6a1026dd6ec5b4f

ARG PACKAGE
RUN --mount=type=bind,from=makepkg,source=/home/makepkg/$PACKAGE,target=/mnt \
    pacman -Sy && pacman -U --noconfirm /mnt/*.pkg.tar.*
