FROM ghcr.io/vaskozl/archlinux:rolling@sha256:9c6052b09d203c311ce369c74facbaeb128401527b09bcb67e02c4d9409937e1

ARG PACKAGE

RUN --mount=type=cache,target=/var/cache/pacman/\
    pacman -Sy --noconfirm $(echo $PACKAGE | tr ',' ' ')
