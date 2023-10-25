FROM ghcr.io/vaskozl/archlinux:latest AS pacstrap

WORKDIR /mnt

ARG NEWROOT=/mnt
ARG PACSTRAP="archlinux-keyring pacman pacman-mirrorlist busybox catatonit"

ARG TARGETARCH CACHE_BUST

# Create basic directories similar in which the system will be installed
RUN \
    mkdir -m 0755 -p $NEWROOT/var/{cache/pacman/pkg,lib/pacman,log} $NEWROOT/{dev,run,etc} && \
    mkdir -m 1777 -p $NEWROOT/tmp && \
    mkdir -m 0555 -p $NEWROOT/{sys,proc} && \
    mknod $NEWROOT/dev/null c 1 3

# Install packages in the new root
RUN --mount=type=cache,sharing=locked,target=/var/cache/pacman/ \
    ln -s /var/cache/pacman $NEWROOT/var/cache/pacman && \
    sed -i '/NoExtract.*etc\/pacman.conf/d' /etc/pacman.conf && \
    pacman -r $NEWROOT -Sy --noconfirm $PACSTRAP && \
    # Install Arch Linux ARM keyring if available
    (pacman -r $NEWROOT -S --noconfirm archlinuxarm-keyring || true) && \
    rm $NEWROOT/dev/null

# amd64 arch comes with all mirrors commented out, use the GeoIP mirror
RUN \
    if [ "$TARGETARCH" = "amd64" ];then \
        echo 'Server = https://geo.mirror.pkgbuild.com/$repo/os/$arch' > $NEWROOT/etc/pacman.d/mirrorlist; \
    fi

FROM scratch
COPY --from=pacstrap /mnt /

# Install busybox at the end of $PATH. GNU versions come first if available
ENV PATH="${PATH}:/opt/busybox/bin"
RUN mkdir -p /opt/busybox/bin && busybox --install -s /opt/busybox/bin

# Set the locale to C.UTF-8 no need for locale-gen
ENV LANG=C.UTF-8
RUN echo "LANG=$LANG" > /etc/locale.conf

# Init the pacman keychain
RUN pacman-key --init && \
    pacman-key --populate && \
    # Remove lsign key
    rm -rf /etc/pacman.d/gnupg/{openpgp-revocs.d/,private-keys-v1.d/,pubring.gpg~,gnupg.S.}*

# Disable docs and locale installatation
RUN --mount=target=/src \
    cat /src/pacman-conf.d-noextract.conf >> /etc/pacman.conf

ENTRYPOINT ["/usr/bin/catatonit", "--"]
