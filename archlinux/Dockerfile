FROM ghcr.io/vaskozl/archlinux:latest AS pacstrap

WORKDIR /mnt

ARG NEWROOT=/mnt
ARG PACSTRAP="archlinux-keyring pacman pacman-mirrorlist pacutils util-linux busybox catatonit"

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
    pacman-key --init && \
    pacman -Sy --noconfirm archlinux-keyring && \
    pacman -r $NEWROOT -Sy --noconfirm $PACSTRAP && \
    # Install Arch Linux ARM keyring if available
    if [ "$TARGETARCH" = "arm64" ]; then \
        pacman -r $NEWROOT -S --noconfirm archlinuxarm-keyring; \
    fi && \
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

# Set the locale to and generate C.UTF-8
ENV LANG=C.UTF-8
RUN echo "LANG=$LANG" > /etc/locale.conf && \
    echo "$LANG UTF-8" > /etc/locale.gen && \
    locale-gen

# Init the pacman keychain
RUN pacman-key --init && \
    pacman-key --populate && \
    # Remove lsign key
    rm -rf /etc/pacman.d/gnupg/{openpgp-revocs.d/,private-keys-v1.d/,pubring.gpg~,gnupg.S.}*

# Fix archlinuxarm build key not being trusted properly
ARG TARGETARCH
RUN if [ "$TARGETARCH" = "arm64" ]; then \
    echo -e "5\ny\n" | gpg --homedir /etc/pacman.d/gnupg --no-tty --command-fd 0 --expert --edit-key builder@archlinuxarm.org trust; \
    fi

# Disable docs and locale installatation
RUN --mount=target=/src \
    cat /src/pacman-conf.d-noextract.conf >> /etc/pacman.conf

# Add unprivileged users
RUN \
    adduser -D -u 568 kah && \
    adduser -D -u 1000 archie

ENTRYPOINT ["/usr/bin/catatonit", "--"]
