FROM menci/archlinuxarm:latest

USER root
WORKDIR /mnt

ARG NEWROOT=/mnt
ARG PACSTRAP="archlinux-keyring pacman pacman-mirrorlist"

RUN --mount=type=cache,target=/var/cache/pacman/\
    mkdir -m 0755 -p $NEWROOT/var/{cache/pacman/pkg,lib/pacman,log} $NEWROOT/{dev,run,etc} \
    && ln -s /var/cache/pacman $NEWROOT/var/cache/pacman \
    && mkdir -m 1777 -p $NEWROOT/tmp \
    && mkdir -m 0555 -p $NEWROOT/{sys,proc} \
    && mknod $NEWROOT/dev/null c 1 3 \
    && pacman -r $NEWROOT -Sy --noconfirm $PACSTRAP \
    && rm $NEWROOT/dev/null \
    # Install Arch Linux ARM keyring if available
    && (pacman -r $NEWROOT -S --noconfirm archlinuxarm-keyring || true) \
    # Remove current pacman database, likely outdated very soon
    && rm $NEWROOT/var/lib/pacman/sync/*

FROM scratch
ARG TARGETARCH
ARG LANG=en_US.UTF-8

COPY --from=0 /mnt /
RUN echo "LANG=$LANG" > /etc/local.conf

ENV LANG=en_US.UTF-8

RUN locale-gen && \
    pacman-key --init && \
    pacman-key --populate archlinux && \
    (pacman-key --populate archlinuxarm || true)

RUN echo "done"

CMD ["/usr/bin/bash"]
