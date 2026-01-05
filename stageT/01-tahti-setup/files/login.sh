#!/bin/sh

read POSTDATA
USER=$(echo "$POSTDATA" | sed -n 's/.*username=\([^&]*\).*/\1/p')
PASS=$(echo "$POSTDATA" | sed -n 's/.*password=\([^&]*\).*/\1/p')

/usr/local/tahti/nds-auth.sh "$USER" "$PASS" "$REMOTE_ADDR"