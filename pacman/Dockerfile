FROM ghcr.io/vaskozl/archlinux:rolling@sha256:5b79c66b91af699a8fd48ba35d4072b620323da77056bd93d299eae06faa4732

ARG PACKAGE

RUN --mount=type=cache,target=/var/cache/pacman/\
    pacman -Sy --noconfirm $(echo $PACKAGE | tr ',' ' ')
