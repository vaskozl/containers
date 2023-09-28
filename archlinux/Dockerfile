FROM menci/archlinuxarm:latest

WORKDIR /mnt

ARG NEWROOT=/mnt
ARG PACSTRAP="archlinux-keyring pacman pacman-mirrorlist busybox"

ARG TARGETARCH CACHE_BUST
RUN --mount=type=cache,target=/var/cache/pacman/ \
    # Create basic directories similar in which the system will be installed
    mkdir -m 0755 -p $NEWROOT/var/{cache/pacman/pkg,lib/pacman,log} $NEWROOT/{dev,run,etc} && \
    ln -s /var/cache/pacman $NEWROOT/var/cache/pacman && \
    mkdir -m 1777 -p $NEWROOT/tmp && \
    mkdir -m 0555 -p $NEWROOT/{sys,proc} && \
    mknod $NEWROOT/dev/null c 1 3 && \

    # Install packages in the new root
    pacman -r $NEWROOT -Sy --noconfirm $PACSTRAP && \
    # Install Arch Linux ARM keyring if available
    (pacman -r $NEWROOT -S --noconfirm archlinuxarm-keyring || true) && \

    # Remove current pacman database, likely outdated very soon
    rm $NEWROOT/var/lib/pacman/sync/* && \
    rm $NEWROOT/dev/null && \

    # amd64 arch comes with all mirrors commented out, use the GeoIP mirror
    if [ "$TARGETARCH" = "amd64" ];then \
        echo 'Server = https://geo.mirror.pkgbuild.com/$repo/os/$arch' > $NEWROOT/etc/pacman.d/mirrorlist; \
    fi && \

    # Remove info, man, docs, locales and zones
    rm -r $NEWROOT/usr/share/info/* && \
    rm -r $NEWROOT/usr/share/man/* && \
    rm -r $NEWROOT/usr/share/doc/* && \
    rm -r $NEWROOT/usr/share/locale && \
    rm -r $NEWROOT/usr/share/zoneinfo/* && \
    rm -r $NEWROOT/usr/share/i18n/* && \

    # Keep only xterm related profiles in terminfo.
    find $NEWROOT/usr/share/terminfo/. ! -name "*xterm*" ! -name "*screen*" ! -name "*screen*" -type f -delete


FROM scratch
ARG LANG=en_US.UTF-8

COPY --from=0 /mnt /
RUN echo "LANG=$LANG" > /etc/local.conf

ENV LANG=en_US.UTF-8

RUN locale-gen && \
    pacman-key --init && \
    pacman-key --populate && \
    rm -rf /etc/pacman.d/gnupg/{openpgp-revocs.d/,private-keys-v1.d/,pubring.gpg~,gnupg.S.}*

# Install busybox at the end of $PATH. GNU coreutils come first if available
ENV PATH="${PATH}:/opt/busybox/bin"
RUN mkdir -p /opt/busybox/bin && busybox --install -s /opt/busybox/bin

CMD ["/usr/bin/bash"]
