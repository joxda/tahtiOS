#!/bin/bash -e

on_chroot << EOF
	export TERM=dumb
	SUDO_USER="${FIRST_USER_NAME}" raspi-config nonint do_wayland W3
EOF
