FROM ghcr.io/vaskozl/archlinux:rolling@sha256:eccfb5416f2e4dc2b4d1aceeace77eee6d12ac17fc73c469c6a1026dd6ec5b4f

ARG PACKAGE

RUN --mount=type=cache,target=/var/cache/pacman/\
    pacman -Sy --noconfirm $(echo $PACKAGE | tr ',' ' ')
