FROM ghcr.io/vaskozl/archlinux:rolling@sha256:cc86f6003c5bebb12600833299f418d7e91fa9f45f103c1d20aebdd6bca0ee4d

RUN --mount=type=cache,target=/var/cache/pacman/\
    pacman -Sy --noconfirm \
        kubectl \
        kubeconform \
        kustomize \
        go-yq

COPY validate /usr/local/bin/
