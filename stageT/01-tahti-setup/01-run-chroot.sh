#!/bin/bash
set -ex
tee -a /tmp/build.log
on_chroot <<EOF | tee /tmp/debug.log
mkdir -p /usr/local/tahti
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
