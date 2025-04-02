#!/bin/bash
set -ex
echo "ROOTFS_DIR is set to: $ROOTFS_DIR"
install -v -d "${ROOTFS_DIR}/usr/local/tahti"
install -v -d "${ROOTFS_DIR}/var/log/nginx "
install -m 644 files/*tar.gz "${ROOTFS_DIR}/usr/local/tahti/"
install -m 644 files/*deb "${ROOTFS_DIR}/usr/local/tahti/"
ls $ROOTFS_DIR/usr/local/
on_chroot <<EOF
install -v -d "${ROOTFS_DIR}/usr/local/tahti"
install -v -d "${ROOTFS_DIR}/var/log/nginx "
cd /usr/local/tahti
echo *.tar.gz
tar xzvf KStars-stable-*-Linux.tar.gz -C /usr/
echo "TAR StellarSolver"
tar xzvf StellarSolver-*-Linux.tar.gz  -C /usr/
echo "TAR indi-lib"
tar xzvf indi-lib-*-Linux.tar.gz  -C /usr/
echo "TAR indi-3rd"
tar xzvf indi-3rd*-*-Linux.tar.gz  -C /usr/
#echo "TAR indi Devel"
#tar xzvf indi-v*-Linux-Devel.tar.gz  -C /usr/
#echo "TAR indi Unspec"
#tar xzvf indi-v*-Linux.tar.gz  -C /usr/
dpkg -i --force-overwrite ./indi-*-Linux.deb
echo "TAR libXISF"
tar xzvf libXISF-*-Linux.tar.gz  -C /usr/
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
sudo rm -f /etc/nginx/sites-enabled/default
sudo apt-get clean
sudo rm -rf /var/log/*
sudo rm -rf /tmp/*
sudo rm -rf /var/tmp/*
sudo apt-get autoremove
rm /usr/local/tahti/*gz
rm /usr/local/tahti/*deb





EOF
