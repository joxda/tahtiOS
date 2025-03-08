#!/bin/bash

sudo -u tahti mkdir /usr/local/tahti
cd /usr/local/tahti
pwd
git clone https://github.com/joxda/astro-soft-build.git
cd astro-soft-build
ls
bash build-fxload.sh
bash build-soft-stable.sh phd2
bash build-more.sh
bash installPythonRelated.sh
bash extra-setup.sh

