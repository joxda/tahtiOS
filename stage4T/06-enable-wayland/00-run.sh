#!/bin/bash -e

on_chroot << EOF
	#export TERM=xterm
	#SUDO_USER="${FIRST_USER_NAME}" raspi-config nonint do_wayland W3
EOF
