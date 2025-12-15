#!/bin/bash

#sudo -u tahti dbus-launch dconf write /org/gnome/desktop/interface/gtk-theme "'PiXnoir'"
#sudo -u tahti dbus-launch dconf write /org/gnome/desktop/interface/font-name "'Piboto Condensed Regular'"

sudo ufw allow "Nginx Full"
sudo ufw allow proto tcp from any to any port 80,443
# Allow INDI server port (default 7624)
sudo ufw allow 7624/tcp
# Allow SSH (optional, if you need remote access)
sudo ufw allow ssh
# Default firewall settings: deny incoming, allow outgoing
sudo ufw default deny incoming
sudo ufw default allow outgoing

sudo /usr/local/tahti/createSSLcertificate.sh

sudo ufw enable
sudo systemctl start ufw
sudo systemctl disable firstboot.service
#rm -- "$0"
