#!/bin/bash
set -e

INTERFACE="wlan0"
TIMEOUT=30

for i in $(seq 1 $TIMEOUT); do
    STATE=$(nmcli -t -f DEVICE,STATE device | grep "^$INTERFACE:" | cut -d: -f2)

    if [ "$STATE" = "connected" ]; then
        exit 0
    fi

    sleep 1
done

systemctl unmask hostapd
systemctl start hostapd
