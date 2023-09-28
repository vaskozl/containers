FROM ghcr.io/vaskozl/archlinux:rolling@sha256:7a3b4a4db8d78e95dc345b8a8d076a6d230db53b804b5508474cea439d1082e8 AS makepkg

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


FROM ghcr.io/vaskozl/archlinux:rolling@sha256:7a3b4a4db8d78e95dc345b8a8d076a6d230db53b804b5508474cea439d1082e8

ARG PACKAGE
RUN --mount=type=bind,from=makepkg,source=/home/makepkg/$PACKAGE,target=/mnt \
    pacman -Sy && pacman -U --noconfirm /mnt/*.pkg.tar.*
