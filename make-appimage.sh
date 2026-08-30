#!/bin/sh

set -eu

ARCH=$(uname -m)
export ARCH
export OUTPATH=./dist
export ADD_HOOKS="self-updater.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=https://raw.githubusercontent.com/Zelda64Recomp/Zelda64Recomp/refs/heads/dev/icons/512.png
export DESKTOP=https://raw.githubusercontent.com/Zelda64Recomp/Zelda64Recomp/refs/heads/dev/.github/linux/Zelda64Recompiled.desktop
export STARTUPWMCLASS=Zelda64Recompiled
export DEPLOY_VULKAN=1

# Deploy dependencies
quick-sharun ./AppDir/bin/Zelda64Recompiled
echo 'SHARUN_WORKING_DIR=${SHARUN_DIR}/bin' >> ./AppDir/.env

# Turn AppDir into AppImage
quick-sharun --make-appimage
