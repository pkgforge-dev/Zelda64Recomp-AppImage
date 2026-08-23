#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
	sdl2	 	   \
	vulkan-headers

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano libdecor-mini

echo "Getting app..."
echo "---------------------------------------------------------------"
case "$ARCH" in # they use X64 and ARM64 for the zip links
	x86_64)  zip_arch=Linux-X64;;
	aarch64) zip_arch=Linux-ARM64;;
esac
ZIP_LINK=$(wget -qO- https://api.github.com/repos/Zelda64Recomp/Zelda64Recomp/releases \
      | sed 's/[()",{} ]/\n/g' | grep -o -m 1 "https.*Zelda64Recompiled.*$zip_arch.zip")
echo "$ZIP_LINK" | awk -F'/' '{gsub(/^v/, "", $(NF-1)); print $(NF-1); exit}' > ~/version
wget --retry-connrefused --tries=30 "$ZIP_LINK" -O /tmp/app.zip

mkdir -p ./AppDir/bin
bsdtar -xvf /tmp/app.zip -C .
bsdtar -xvf ./Zelda64Recompiled.tar.gz -C ./AppDir/bin
wget -q -O ./AppDir/bin/recompcontrollerdb.txt https://raw.githubusercontent.com/mdqinc/SDL_GameControllerDB/master/gamecontrollerdb.txt
