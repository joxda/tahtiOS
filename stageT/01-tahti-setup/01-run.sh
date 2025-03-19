#!/bin/bash
set -ex
echo "ROOTFS_DIR is set to: $ROOTFS_DIR"
install -v -d "${ROOTFS_DIR}/usr/local/tahti"
ls $ROOTFS_DIR/usr/local/
on_chroot <<EOF
install -v -d "${ROOTFS_DIR}/usr/local/tahti"
cd /usr/local/tahti
git clone https://github.com/joxda/astro-soft-build.git
cd astro-soft-build
echo "cmake_minimum_required(VERSION 3.0)" > CMakeLists.txt
echo "project(TempProject)" >> CMakeLists.txt
echo "find_package(USB1 REQUIRED)" >> CMakeLists.txt
cmake . -LA | grep USB1
chmod +x *.sh
#bash build-fxload.sh
./build-soft.sh #phd2
./build-more.sh
./installPythonRelated.sh
./extra-setup.sh
EOF
