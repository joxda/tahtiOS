#!/bin/sh

IFACE="$1"
STATE="$2"

if [ "$IFACE" = "wlan0" ]; then
  case "$STATE" in
    up)
      systemctl start nodogsplash
      ;;
    down)
      systemctl stop nodogsplash
      ;;
  esac
fi
