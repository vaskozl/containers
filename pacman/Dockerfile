FROM ghcr.io/vaskozl/archlinux:rolling@sha256:412c8db2c15d5c167e86e58cd728da35c2d1fe2267bff5b44bf059c368ea0990

ARG PACKAGE

RUN --mount=type=cache,target=/var/cache/pacman/\
    pacman -Sy --noconfirm $(echo $PACKAGE | tr ',' ' ')
