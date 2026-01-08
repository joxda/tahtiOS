#!/bin/bash
set -ex
echo "ROOTFS_DIR is set to: $ROOTFS_DIR"
install -m 644 -D files/user-data "${ROOTFS_DIR}/boot/firmware/user-data"
install -m 644 -D files/network-config "${ROOTFS_DIR}/boot/firmware/network-config"
install -v -d "${ROOTFS_DIR}/usr/local/tahti"
install -m 644 files/*tar.gz "${ROOTFS_DIR}/usr/local/tahti/"
install -m 644 files/*deb "${ROOTFS_DIR}/usr/local/tahti/"
install -m 644 -D files/desktop-items-NOOP-1.conf "${ROOTFS_DIR}/home/tahti/.config/pcmanfm/default/desktop-items-NOOP-1.conf"
install -m 644 -D files/nodogsplashpam "${ROOTFS_DIR}/etc/pam.d/nodogsplash"
install -m 644 -D files/nodogsplash.conf "${ROOTFS_DIR}/usr/local/tahti/nodogsplashstuff/nodogsplash.conf"
install -m 644 -D files/splash.html "${ROOTFS_DIR}/usr/local/tahti/nodogsplashstuff/htdocs/splash.html"
install -m 755 -D files/login.sh "${ROOTFS_DIR}/etc/nodogsplash/htdocs/cgi-bin/login.sh"
install -m 755 -D files/nds-auth.sh "${ROOTFS_DIR}/usr/local/tahti/nds-auth.sh"
install -m 755 -D files/nodogsplashdispatcher.sh "${ROOTFS_DIR}/etc/NetworkManager/dispatcher.d/90-nodogsplash"
install -m 644 -D files/wifi-powersave-off.conf "${ROOTFS_DIR}/etc/NetworkManager/conf.d/wifi-powersave-off.conf"
install -m 644 -D files/wifi-enable-autohotspot.conf "${ROOTFS_DIR}/etc/NetworkManager/conf.d/wifi-enable-autohotspot.conf"
install -m 600 -D files/HotSpot.nmconnection "${ROOTFS_DIR}/etc/NetworkManager/system-connections/HotSpot.nmconnection"

on_chroot <<EOF
cd /usr/local/tahti
git clone --branch v5.0.2 --depth 1 https://github.com/nodogsplash/nodogsplash.git
cd nodogsplash
make
make install
cd ..
mv /etc/nodogsplash/nodogsplash.conf /etc/nodogsplash/nodogsplash.bkp
mv /etc/nodogsplash/htdocs/splash.html /etc/nodogsplash/htdocs/splash.html.bkp
install -m 644 -D nodogsplashstuff/nodogsplash.conf "/etc/nodogsplash/nodogsplash.conf"
install -m 644 -D nodogsplashstuff/htdocs/splash.html "/etc/nodogsplash/htdocs/splash.html"
cd ..
rm -rf nodogsplash
echo *.tar.gz
cd /usr/local/tahti
tar xzvf KStars-stable-*-Linux.tar.gz -C /usr/
echo "TAR StellarSolver"
tar xzvf StellarSolver-*-Linux.tar.gz  -C /usr/
#echo "TAR indi-lib"
#tar xzvf indi-lib-*-Linux.tar.gz  -C /usr/
#echo "TAR indi-3rd"
#tar xzvf indi-3rd*-*-Linux.tar.gz  -C /usr/
dpkg -i --force-overwrite ./indi-*-Linux.deb
echo "TAR libXISF"
tar xzvf libXISF-*-Linux.tar.gz  -C /usr/
git clone --branch j3 https://github.com/joxda/astro-soft-build.git
cd astro-soft-build
chmod +x *.sh
SUDO_USER="${FIRST_USER_NAME}" ./build-more.sh
SUDO_USER="${FIRST_USER_NAME}" ./installPythonRelated.sh
SUDO_USER="${FIRST_USER_NAME}" ./extra-setup.sh
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
systemctl disable userconfig
systemctl mask userconfig
systemctl --quiet set-default graphical.target
systemctl disable vncserver-x11-serviced.service
systemctl stop vncserver-x11-serviced.service
systemctl enable wayvnc.service

systemctl enable NetworkManager

rm -f /etc/nginx/sites-enabled/default
rm -rf /var/log/*
install -v -d "/var/log/nginx"
chown -R tahti:tahti /usr/local/tahti
chown -R tahti:tahti /home/tahti/.config
rm -rf /tmp/*
rm -rf /var/tmp/*
apt-get -y autoremove && apt-get -y clean
rm /usr/local/tahti/*gz
rm /usr/local/tahti/*deb
EOF
rm files/*
