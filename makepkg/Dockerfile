FROM ghcr.io/vaskozl/archlinux:rolling as makepkg

RUN --mount=type=cache,target=/var/cache/pacman/\
    pacman -S --noconfirm git base-devel sudo shadow pacutils pacman-contrib python-setuptools

# Add a non-root user for building AUR packages
ARG USER=makepkg
RUN useradd --system --create-home $USER  && \
    echo "$USER ALL=(ALL:ALL) NOPASSWD:ALL" > /etc/sudoers.d/$USER


# Init ithe [custom] repo in bind mounted cache
ARG REPO_DIR=/home/custompkgs
RUN --mount=type=cache,sharing=locked,target=/home/custompkgs\
    install -o $USER -dm755 $REPO_DIR

USER $USER
WORKDIR /home/$USER

# Build aurutils and init [custom]
RUN --mount=type=cache,sharing=locked,target=/var/cache/pacman/\
    --mount=type=cache,sharing=locked,target=/home/custompkgs\
    git clone --depth=1 https://aur.archlinux.org/aurutils.git && \
    cd aurutils && \
    makepkg -s --noconfirm && \
    mv *.pkg.tar.* $REPO_DIR/ && \
    repo-add -R $REPO_DIR/custom.db.tar $REPO_DIR/aurutils-*.pkg.tar.*

USER root

# Enable the [custom] repo
RUN perl -0777 -pi -e 's/#(\[custom\])\n#(SigLevel.*)\n#(Server.*)\n/$1\n$2\n$3\n/' /etc/pacman.conf

# Install aurutils
RUN --mount=type=cache,sharing=locked,target=/var/cache/pacman/\
    --mount=type=cache,sharing=locked,target=/home/custompkgs\
    pacsync custom && \
    pacman -S --noconfirm aurutils

USER $USER

# Build AUR packages
ARG AURS CACHE_BUST
RUN IFS=','; read -ra AURS <<< "$AURS"
# Sync deps first so we don't lock the cache during the build
RUN --mount=type=cache,sharing=locked,target=/var/cache/pacman/\
    --mount=type=cache,sharing=locked,target=/home/custompkgs\
    --mount=target=/src \
    IFS=','; read -ra AURS <<< "$AURS"; \
    for aur_pkg in "${AURS[@]}"; do \
        aur sync --noconfirm --noview --ignorearch ${aur_pkg}; \
    done && \
    sudo paccache -rk 1 && \
    sudo paccache -c $REPO_DIR -rk 1

FROM ghcr.io/vaskozl/archlinux:rolling

COPY --from=0 /etc/pacman.conf /etc/pacman.conf

ARG PKGS AURS PKGNAME VERSION CACHE_BUST

RUN --mount=type=cache,sharing=locked,target=/home/custompkgs\
    --mount=type=cache,sharing=locked,target=/var/cache/pacman/\
    pacsync custom && \
    IFS=','; read -ra PKGS <<< "$PKGS"; \
    IFS=','; read -ra AURS <<< "$AURS"; \
    pacman -S --noconfirm ${AURS[@]} ${PKGS[@]} && \
    if [ -n "$PKGNAME" ] && ! pacman -Q $PKGNAME | grep -F "$VERSION"; then \
        echo "Expected $VERSION but got $(pacman -Q $PKGNAME)" && exit 1; \
    fi

RUN --mount=target=/src \
    if [ -d "/src/makepkg/files" ]; then \
        cp -r /src/makepkg/files/. /; \
    fi; \
    if [ -d "/src/$PKGNAME/files" ]; then \
        cp -r /src/$PKGNAME/files/. /; \
    fi;

RUN if [ -e "/usr/local/bin/post-install.sh" ]; then /usr/local/bin/post-install.sh;fi

ARG EXEC
ENV EXEC=$EXEC

ENTRYPOINT ["/usr/bin/catatonit", "--", "/usr/local/bin/entrypoint.sh"]
