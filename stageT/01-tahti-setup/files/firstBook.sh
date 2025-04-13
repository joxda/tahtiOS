#!/bin/bash

sudo -u tahti dbus-launch dconf write /org/gnome/desktop/interface/gtk-theme "'PiXnoir'"
sudo -u tahti dbus-launch dconf write /org/gnome/desktop/interface/font-name "'Piboto Condensed Regular'"

# Allow INDI server port (default 7624)
ufw allow 7624/tcp
# Allow SSH (optional, if you need remote access)
ufw allow ssh
# Default firewall settings: deny incoming, allow outgoing
ufw default deny incoming
ufw default allow outgoing

ufw enable --force


systemctl disable firstboot.service

rm -- "$0"