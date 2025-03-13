#!/bin/bash
set -ex
tee -a /tmp/build.log
install -m 755 -o 1000 -g 1000 -d "${ROOTFS_DIR}/usr/local/tahti"
on_chroot <<EOF
cd /usr/local/tahti
git clone https://github.com/joxda/astro-soft-build.git
cd astro-soft-build
ls
chmos +x *.sh
#bash build-fxload.sh
./build-soft-stable.sh phd2
./build-more.sh
./installPythonRelated.sh
./extra-setup.sh
EOF
