FROM manjarolinux/base:20230917

RUN --mount=type=cache,target=/var/cache/pacman/\
    pacman -Sy --noconfirm \
        kubectl \
        kubeconform \
        kustomize \
        go-yq

COPY validate /usr/local/bin/
