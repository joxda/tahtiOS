#!/bin/bash

echo "=== QEMU Version ==="
qemu-aarch64-static --version

echo "=== CPU Info ==="
lscpu

echo "=== Kernel Info ==="
uname -a
