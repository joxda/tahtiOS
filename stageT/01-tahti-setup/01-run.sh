#!/bin/bash
set -ex
echo "ROOTFS_DIR is set to: $ROOTFS_DIR"
install -v -d "${ROOTFS_DIR}/usr/local/tahti"
install -m 644 files/*tar.gz "${ROOTFS_DIR}/usr/local/tahti/"
ls $ROOTFS_DIR/usr/local/
on_chroot <<EOF
install -v -d "${ROOTFS_DIR}/usr/local/tahti"
cd /usr/local/tahti
ls
echo "here"
echo *.tar.gz
for file in *.tar.gz; do
    echo "This $file"
    #tar xzvf "$file" -C /usr/ --strip-components=1
done
tar xzvf KStars-stable-*-Linux.tar.gz -C /usr/ --strip-components=1
tar xzvf StellarSolver-*-Linux.tar.gz  -C /usr/ --strip-components=1
tar xzvf indi-lib-v*-Linux.tar.gz  -C /usr/ --strip-components=1
tar xzvf indi-v*-Linux.tar.gz  -C /usr/ --strip-components=1
tar xzvf libXISF-v*-Linux.tar.gz  -C /usr/ --strip-components=1
git clone https://github.com/joxda/astro-soft-build.git
cd astro-soft-build
#echo "cmake_minimum_required(VERSION 3.0)" > CMakeLists.txt
#echo "project(TempProject)" >> CMakeLists.txt
#echo "find_package(USB1 REQUIRED)" >> CMakeLists.txt
#cmake . -LA | grep USB1
chmod +x *.sh
#bash build-fxload.sh
#./build-soft.sh #phd2
./build-more.sh
./installPythonRelated.sh
./extra-setup.sh
EOF
