FROM ghcr.io/vaskozl/archlinux:rolling@sha256:5b79c66b91af699a8fd48ba35d4072b620323da77056bd93d299eae06faa4732 AS makepkg

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


FROM ghcr.io/vaskozl/archlinux:rolling@sha256:5b79c66b91af699a8fd48ba35d4072b620323da77056bd93d299eae06faa4732

ARG PACKAGE
RUN --mount=type=bind,from=makepkg,source=/home/makepkg/$PACKAGE,target=/mnt \
    pacman -Sy && pacman -U --noconfirm /mnt/*.pkg.tar.*
