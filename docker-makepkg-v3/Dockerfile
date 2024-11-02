FROM archlinux:base-devel

# COPY needed files
COPY run.sh /run.sh
COPY pacman.conf /etc/pacman.conf
COPY rust.conf /etc/makepkg.conf.d/rust.conf
COPY ccache.conf /etc/ccache.conf
COPY cachyos-mirrorlist /etc/pacman.d/cachyos-mirrorlist
COPY cachyos-v3-mirrorlist /etc/pacman.d/cachyos-v3-mirrorlist
COPY cachyos-v4-mirrorlist /etc/pacman.d/cachyos-v4-mirrorlist
COPY mirrorlist /etc/pacman.d/mirrorlist
# makepkg cannot (and should not) be run as root:

RUN sudo pacman-key --init && sudo pacman-key --recv-keys F3B607488DB35A47 --keyserver keyserver.ubuntu.com && \
    sudo pacman-key --lsign-key F3B607488DB35A47
#    sudo pacman -U 'https://mirror.cachyos.org/repo/x86_64/cachyos/cachyos-keyring-20240331-1-any.pkg.tar.zst'

# Generally, refreshing without sync'ing is discouraged, but we've a clean
# environment here.
RUN useradd -m notroot && \
    pacman -Syu --noconfirm && \
    pacman -Sy --noconfirm git && \
    # Allow notroot to run stuff as root (to install dependencies):
    echo "notroot ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/notroot

# Continue execution (and CMD) as notroot:
USER notroot
WORKDIR /home/notroot
COPY privkey.asc /home/notroot/privkey.asc

# Auto-fetch GPG keys (for checking signatures):
# hadolint ignore=DL3003
RUN mkdir .gnupg && \
    touch .gnupg/gpg.conf && \
    echo "keyserver-options auto-key-retrieve" > .gnupg/gpg.conf && \
    sudo pacman -Sy --noconfirm lib32-gcc-libs paru mold pacman-contrib zstd zlib-ng-compat lib32-zlib-ng-compat cachyos-rate-mirrors && \
    sudo pacman -Syu --noconfirm

RUN sudo pacman-key --init && \
    sudo pacman-key --recv-keys F3B607488DB35A47 --keyserver keyserver.ubuntu.com && \
    sudo pacman-key --lsign-key F3B607488DB35A47 && \
    sudo pacman -U --noconfirm 'https://mirror.cachyos.org/repo/x86_64/cachyos/cachyos-keyring-20240331-1-any.pkg.tar.zst' 'https://mirror.cachyos.org/repo/x86_64/cachyos/cachyos-mirrorlist-18-1-any.pkg.tar.zst' 'https://mirror.cachyos.org/repo/x86_64/cachyos/cachyos-v3-mirrorlist-18-1-any.pkg.tar.zst' 'https://mirror.cachyos.org/repo/x86_64/cachyos/cachyos-v4-mirrorlist-6-1-any.pkg.tar.zst' && \
    sudo cachyos-rate-mirrors

COPY makepkg.conf /etc/makepkg.conf

# Build the package
WORKDIR /pkg
CMD ["/bin/bash", "/run.sh"]
