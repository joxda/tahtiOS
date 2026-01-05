#!/bin/sh

USERNAME="$1"
PASSWORD="$2"
CLIENTMAC="$3"

if echo "$PASSWORD" | pamtester nodogsplash "$USERNAME" authenticate >/dev/null 2>&1; then
  ndsctl auth "$CLIENTMAC"
  exit 0
fi

exit 1