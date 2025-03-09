#!/bin/bash -e

if [ ! -d "${ROOTFS_DIR}" ]; then
	copy_previous
fi


sudo chroot ${ROOTFS_DIR} /bin/bash
uname -m
gcc -v
