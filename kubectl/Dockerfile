FROM ghcr.io/vaskozl/archlinux:rolling@sha256:a20c0e51ca7223c42c94677bcb26e706de24b6416a08c64e61abd9b7c67a066b

RUN --mount=type=cache,target=/var/cache/pacman/\
    pacman -Sy --noconfirm \
        kubectl \
        kubeconform \
        kustomize \
        go-yq

COPY validate /usr/local/bin/
