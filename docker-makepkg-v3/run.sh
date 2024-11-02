#!/bin/bash

set -e

# Make a copy so we never alter the original
cp -r /pkg /tmp/pkg
cd /tmp/pkg

# Sync database
if [ -n "$SYNC_DATABASE" ]; then
    sudo pacman -Sy
fi

# Use bolted LLVM
if [ -n "$LLVM_BOLT" ]; then
    export PATH=/home/notroot/llvm/bin:${PATH}
fi

## Create packages directory
mkdir /home/notroot/packages

echo "Updating packages"

sudo pacman -Syyu --noconfirm

## Update checksums and generate .SRCINFO before building
if [ -n "$CHECKSUMS" ]; then
    echo "updating checksums"
    updpkgsums
    makepkg --printsrcinfo > .SRCINFO
else
    echo "not updating checksums"
fi
# Do the actual building. Paru will fetch all dependencies for us (including
# AUR dependencies) and then build the package.
## USE PARU FOR AUR PACKAGES
if [ -n "$USE_PARU" ]; then
    paru -U --noconfirm --cleanafter
else
    makepkg -sc --skipinteg --noconfirm --log || true
fi

# Store the built package(s). Ensure permissions match the original PKGBUILD.
if [ -n "$EXPORT_PKG" ]; then
    sudo chown "$(stat -c '%u:%g' /pkg/PKGBUILD)" /home/notroot/packages/*
    sudo mv /home/notroot/packages/*.log /pkg || true
    sudo mv /home/notroot/packages/*pkg.tar* /pkg || true
fi

# Export .SRCINFO for built package ## Actually we dont use this feature
if [ -n "$EXPORT_SRCINFO" ]; then
    makepkg --printsrcinfo > .SRCINFO
    sudo chown "$(stat -c '%u:%g' /pkg/PKGBUILD)" ./.SRCINFO
    sudo mv ./.SRCINFO /pkg
fi
#rm -rf /tmp/makepkg
