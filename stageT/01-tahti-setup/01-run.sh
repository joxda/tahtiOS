#!/bin/bash
set -ex
echo "ROOTFS_DIR is set to: $ROOTFS_DIR"
install -v -d "${ROOTFS_DIR}/usr/local/tahti"
install -m 644 files/*tar.gz "${ROOTFS_DIR}/usr/local/tahti/"
install -m 644 files/*deb "${ROOTFS_DIR}/usr/local/tahti/"
install -m 644 -D files/autologin.conf "${ROOTFS_DIR}/etc/systemd/system/getty@tty1.service.d/autologin.conf"
install -m 644 -D files/rc.xml "${ROOTFS_DIR}/home/tahti/.config/labwc/rc.xml"
install -m 644 -D files/themerc-override "${ROOTFS_DIR}/home/tahti/.config/labwc/themerc-override"
install -m 644 -D files/desktop-items-NOOP-1.conf "${ROOTFS_DIR}/home/tahti/.config/pcmanfm/LXDE-pi/desktop-items-NOOP-1.conf"
install -m 755 files/*sh "${ROOTFS_DIR}/usr/local/tahti/"
install -m 644 files/firstboot.service "${ROOTFS_DIR}/etc/systemd/system/"
on_chroot <<EOF
cd /usr/local/tahti
echo *.tar.gz
tar xzvf KStars-stable-*-Linux.tar.gz -C /usr/
echo "TAR StellarSolver"
tar xzvf StellarSolver-*-Linux.tar.gz  -C /usr/
echo "TAR indi-lib"
tar xzvf indi-lib-*-Linux.tar.gz  -C /usr/
echo "TAR indi-3rd"
tar xzvf indi-3rd*-*-Linux.tar.gz  -C /usr/
dpkg -i --force-overwrite ./indi-*-Linux.deb
echo "TAR libXISF"
tar xzvf libXISF-*-Linux.tar.gz  -C /usr/
git clone https://github.com/joxda/astro-soft-build.git
cd astro-soft-build
chmod +x *.sh
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
systemctl disable userconfig
systemctl mask userconfig
systemctl --quiet set-default graphical.target
sed /etc/lightdm/lightdm.conf -i -e "s/^\(#\|\)autologin-user=.*/autologin-user=$FIRST_USER_NAME/"
sed /etc/lightdm/lightdm.conf -i -e "s/^#\\?user-session.*/user-session=LXDE-pi-labwc/"
sed /etc/lightdm/lightdm.conf -i -e "s/^#\\?autologin-session.*/autologin-session=LXDE-pi-labwc/"
sed /etc/lightdm/lightdm.conf -i -e "s/^#\\?greeter-session.*/greeter-session=pi-greeter-labwc/"
sed /etc/lightdm/lightdm.conf -i -e "s/^fallback-test.*/#fallback-test=/"
sed /etc/lightdm/lightdm.conf -i -e "s/^fallback-session.*/#fallback-session=/"
sed /etc/lightdm/lightdm.conf -i -e "s/^fallback-greeter.*/#fallback-greeter=/"
systemctl disable vncserver-x11-serviced.service
systemctl stop vncserver-x11-serviced.service
systemctl enable wayvnc.service
systemctl enable firstboot.service
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
