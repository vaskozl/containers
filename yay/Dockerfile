FROM ghcr.io/vaskozl/archlinux:rolling@sha256:5b79c66b91af699a8fd48ba35d4072b620323da77056bd93d299eae06faa4732

RUN --mount=type=cache,target=/var/cache/pacman/\
    pacman -Sy --needed --noconfirm git base-devel sudo shadow

ARG user=makepkg
RUN useradd --system --create-home $user \
  && echo "$user ALL=(ALL:ALL) NOPASSWD:ALL" > /etc/sudoers.d/$user
USER $user
WORKDIR /home/$user

RUN --mount=type=cache,target=/var/cache/pacman/\
    git clone https://aur.archlinux.org/yay.git && \
    cd yay && \
    makepkg -si --needed --noconfirm && \
    rm -rf .cache yay
