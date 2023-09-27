FROM ghcr.io/vaskozl/archlinux:rolling@sha256:698a4932c2ad26f34039318c3aa381a9eca96d26a968868ace6e9a0d65d1eaab

RUN --mount=type=cache,target=/var/cache/pacman/\
    pacman -Sy --noconfirm \
        kubectl \
        kubeconform \
        kustomize \
        go-yq

COPY validate /usr/local/bin/
