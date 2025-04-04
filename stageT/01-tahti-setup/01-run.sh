#!/bin/bash
set -ex
echo "ROOTFS_DIR is set to: $ROOTFS_DIR"
install -v -d "${ROOTFS_DIR}/usr/local/tahti"
install -v -d "${ROOTFS_DIR}/var/log/nginx"
install -m 644 files/*tar.gz "${ROOTFS_DIR}/usr/local/tahti/"
install -m 644 files/*deb "${ROOTFS_DIR}/usr/local/tahti/"
ls $ROOTFS_DIR/usr/local/
on_chroot <<EOF
install -v -d "${ROOTFS_DIR}/usr/local/tahti"
install -v -d "${ROOTFS_DIR}/var/log/nginx"
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
cd /usr/share
git clone --branch v1.6.0 --depth 1 https://github.com/novnc/noVNC.git
cd /usr/local/tahti/repos/
git clone --depth 1 https://github.com/joxda/libXISF.git
git clone --depth 1 https://github.com/indilib/indi.git
git clone --depth 1 https://github.com/indilib/indi-3rdparty.git
git clone --depth 1 https://github.com/rlancaste/stellarsolver.git 
git clone --depth 1 https://invent.kde.org/education/kstars.git
systemctl disable userconfig
systemctl mask userconfig
raspi-config nonint do_boot_behaviour B3
#raspi-config nonint do_vnc_resolution <width>x<height>
raspi-config nonintdo_wayland W2
raspi-config nonint do_vnc 0
rm -f /etc/nginx/sites-enabled/default
apt-get clean
rm -rf /var/log/*
rm -rf /tmp/*
rm -rf /var/tmp/*
apt-get autoremove
rm /usr/local/tahti/*gz
rm /usr/local/tahti/*deb
EOF
rm files/*
