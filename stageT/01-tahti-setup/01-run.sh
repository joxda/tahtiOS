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
SUDO_USER="${FIRST_USER_NAME}" ./build-more.sh
SUDO_USER="${FIRST_USER_NAME}" ./installPythonRelated.sh
./extra-setup.sh
cd /usr/share
git clone --branch v1.6.0 --depth 1 https://github.com/novnc/noVNC.git
cd /usr/local/tahti/repos/

SUDO_USER="${FIRST_USER_NAME}" git clone --filter=blob:none --no-checkout https://github.com/joxda/libXISF.git
cd libXISF
git sparse-checkout init --cone
git sparse-checkout set README.md LICENSE
git checkout master
git sparse-checkout set --cone ""
cd ..
SUDO_USER="${FIRST_USER_NAME}" git clone --filter=blob:none --no-checkout https://github.com/indilib/indi.git
cd indi
git sparse-checkout init --cone
git sparse-checkout set README.md LICENSE
git checkout master
git sparse-checkout set --cone ""
cd ..
SUDO_USER="${FIRST_USER_NAME}" git clone --filter=blob:none --no-checkout https://github.com/indilib/indi-3rdparty.git
cd indi-3rdparty
git sparse-checkout init --cone
git sparse-checkout set README.md LICENSE
git checkout master
git sparse-checkout set --cone ""
cd ..
SUDO_USER="${FIRST_USER_NAME}" git clone --filter=blob:none --no-checkout https://github.com/rlancaste/stellarsolver.git 
cd stellarsolver
git sparse-checkout init --cone
git sparse-checkout set README.md LICENSE
git checkout master
git sparse-checkout set --cone ""
cd ..
SUDO_USER="${FIRST_USER_NAME}" git clone --filter=blob:none --no-checkout https://invent.kde.org/education/kstars.git
cd kstars
git sparse-checkout init --cone
git sparse-checkout set README.md LICENSE
git checkout master
git sparse-checkout set --cone ""
cd ..
git clone --depth 1 https://github.com/rkaczorek/astroberry-server-sysmod.git
cd astroberry-server-sysmod
cmake .
make
make install
cd ..
systemctl disable userconfig
systemctl mask userconfig
SUDO_USER="${FIRST_USER_NAME}" raspi-config nonint do_boot_behaviour B4
#raspi-config nonint do_vnc_resolution <width>x<height>
SUDO_USER="${FIRST_USER_NAME}" raspi-config nonint do_wayland W2
SUDO_USER="${FIRST_USER_NAME}" raspi-config nonint do_vnc 0
rm -f /etc/nginx/sites-enabled/default
rm -rf /var/log/*
rm -rf /tmp/*
rm -rf /var/tmp/*
apt-get -y autoremove && apt-get -y clean
rm /usr/local/tahti/*gz
rm /usr/local/tahti/*deb
EOF
rm files/*
