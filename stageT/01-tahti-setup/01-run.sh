#!/bin/bash
set -ex
echo "ROOTFS_DIR is set to: $ROOTFS_DIR"
install -m 644 -D files/user-data "${ROOTFS_DIR}/boot/firmware/user-data"
install -m 644 -D files/network-config "${ROOTFS_DIR}/boot/firmware/network-config"
install -v -d "${ROOTFS_DIR}/usr/local/tahti"
install -m 644 files/*tar.gz "${ROOTFS_DIR}/usr/local/tahti/"
install -m 644 files/*deb "${ROOTFS_DIR}/usr/local/tahti/"
install -m 644 -D files/desktop-items-NOOP-1.conf "${ROOTFS_DIR}/home/tahti/.config/pcmanfm/default/desktop-items-NOOP-1.conf"
install -m 644 -D files/hostapd-radius.conf "${ROOTFS_DIR}/etc/hostapd/hostapd-radius.conf"
install -m 755 -D files/wifi-fallback.sh "${ROOTFS_DIR}/usr/local/tahti/wifi-fallback.sh"
install -m 644 -D files/wifi-fallback.service "${ROOTFS_DIR}/etc/systemd/system/wifi-fallback.service"
on_chroot <<EOF
cd /usr/local/tahti
echo *.tar.gz
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
git clone https://github.com/joxda/astro-soft-build.git
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
systemctl disable hostapd
systemctl mask hostapd
echo "pam {\n    pam_auth = radius\n}" > /etc/freeradius/3.0/mods-enabled/pam
echo "auth    required pam_unix.so\naccount required pam_unix.so" > /etc/pam.d/radius
sed -i '/authorize {/a\    pam' /etc/freeradius/3.0/sites-enabled/default
sed -i '/authenticate {/a\    pam' /etc/freeradius/3.0/sites-enabled/default
echo "\nclient localhost {\n    ipaddr = 127.0.0.1\n    secret = radiussecret\n}" >> /etc/freeradius/3.0/clients.conf
systemctl enable freeradius
echo 'DAEMON_CONF="/etc/hostapd/hostapd-radius.conf"' > /etc/default/hostapd
systemctl enable wifi-fallback.service

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
