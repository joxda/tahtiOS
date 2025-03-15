#!/bin/bash
set -ex
echo "ROOTFS_DIR is set to: $ROOTFS_DIR"
install -v -d "${ROOTFS_DIR}/usr/local/tahti"
ls $ROOTFS_DIR/usr/local/
on_chroot <<EOF
cd /usr/local/tahti
git clone https://github.com/joxda/astro-soft-build.git
cd astro-soft-build
ls
chmod +x *.sh
#bash build-fxload.sh
./build-soft-stable.sh phd2
./build-more.sh
./installPythonRelated.sh
./extra-setup.sh
EOF
