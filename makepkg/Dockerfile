FROM ghcr.io/vaskozl/archlinux:rolling as makepkg

RUN --mount=type=cache,target=/var/cache/pacman/\
    pacman -S --noconfirm git base-devel sudo shadow

ARG USER=makepkg
RUN useradd --system --create-home $USER  && \
    echo "$USER ALL=(ALL:ALL) NOPASSWD:ALL" > /etc/sudoers.d/$USER

USER $USER
WORKDIR /home/$USER

ARG AURS
RUN IFS=','; read -ra AURS <<< "$AURS"
# Sync deps first so we don't lock the cache during the build
RUN --mount=type=cache,sharing=locked,target=/var/cache/pacman/\
    IFS=','; read -ra AURS <<< "$AURS"; \
    for aur_pkg in "${AURS[@]}"; do \
        git clone --depth=1 https://aur.archlinux.org/${aur_pkg}.git && \
        cd ~/$aur_pkg && \
        # Optimistically build for any arch
        sed -i "s/^arch=.*/arch=('any')/" PKGBUILD && \
        makepkg --syncdeps --nobuild --noconfirm && \
        cd ~; \
    done

RUN \
    IFS=','; read -ra AURS <<< "$AURS"; \
    for aur_pkg in "${AURS[@]}"; do \
        cd ~/$aur_pkg && makepkg --noconfirm; \
    done

FROM ghcr.io/vaskozl/archlinux:rolling

ARG PKGS AURS EXP_PKG EXP_VER

RUN --mount=type=bind,from=makepkg,source=/home/makepkg/,target=/mnt \
    --mount=type=cache,sharing=locked,target=/var/cache/pacman/\
    IFS=','; read -ra PKGS <<< "$PKGS"; \
    if [ -z "$AURS" ] && [ -z "$PKGS" ]; then echo 'No AURS or PKGS'; exit 1; fi && \
    if [ -n "$AURS" ]; then pacman -U --noconfirm /mnt/*/*.pkg.tar.*; fi && \
    if [ -n "$PKGS" ]; then pacman -S --noconfirm ${PKGS[@]}; fi && \
    if ! pacman -Q $EXP_PKG | grep -F "$EXP_VER"; then \
        echo "Expected $EXP_VER but got $(pacman -Q $EXP_PKG)" && exit 1; \
    fi
