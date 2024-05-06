FROM fedora:rawhide AS installer

ARG PKGS="coreutils-single glibc-minimal-langpack catatonit busybox"

# Install packages in the new root
RUN --mount=type=cache,sharing=locked,target=/mnt/var/cache/dnf \
    dnf install --installroot=/mnt --setopt install_weak_deps=false --nodocs -y $PKGS

RUN rm -rf /mnt/var/cache/* /mnt/var/log/dnf* /mnt/var/log/yum.* /mnt/usr/share/zoneinfo


FROM scratch
COPY --from=installer /mnt /

# Install busybox at the end of $PATH. GNU versions come first if available
ENV PATH="${PATH}:/opt/busybox/bin"
RUN /usr/sbin/busybox mkdir -p /opt/busybox/bin && /usr/sbin/busybox --install -s /opt/busybox/bin

ENTRYPOINT ["/usr/libexec/catatonit/catatonit", "--", "bash"]
