FROM ghcr.io/vaskozl/archlinux:rolling@sha256:7a3b4a4db8d78e95dc345b8a8d076a6d230db53b804b5508474cea439d1082e8

ARG PACKAGE

RUN --mount=type=cache,target=/var/cache/pacman/\
    pacman -Sy --noconfirm $(echo $PACKAGE | tr ',' ' ')
