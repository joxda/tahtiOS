#!/bin/bash -e -x
tee -a /build.log
on_chroot <<EOF
mkdir /usr/local/tahti
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
