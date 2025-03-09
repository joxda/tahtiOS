#!/bin/bash -e

echo "Start"

on_chroot << EOF
sudo -u tahti mkdir /usr/local/tahti
cd /usr/local/tahti
echo 'export CFLAGS="-march=armv8-a -mtune=cortex-a72 -mno-outline-atomics"' >> /etc/profile
echo 'export CXXFLAGS="-march=armv8-a -mtune=cortex-a72 -mno-outline-atomics"' >> /etc/profile
echo 'export CC="aarch64-linux-gnu-gcc"' >> /etc/profile
echo 'export CXX="aarch64-linux-gnu-g++"' >> /etc/profile

git clone https://github.com/joxda/astro-soft-build.git
cd astro-soft-build
ls
bash build-fxload.sh
bash build-soft-stable.sh phd2
bash build-more.sh
bash installPythonRelated.sh
bash extra-setup.sh
EOF

echo "End"