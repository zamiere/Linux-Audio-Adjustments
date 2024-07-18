#!/bin/bash

border()
{
    local title="| $1 |"
    local edge=${title//?/-}
    echo -e "${edge}\n${title}\n${edge}"
    sleep 4
}

border 'Removing Linux Audio Tuning'

[[ -f /usr/bin/Sound.sh ]] && rm /usr/bin/Sound.sh
[[ -f /etc/sysctl.d/network-latency.conf ]] && rm /etc/sysctl.d/network-latency.conf
[[ -f /etc/udev/rules.d/40-timer-permissions.rules ]] && rm /etc/udev/rules.d/40-timer-permissions.rules
[[ -f /etc/tmpfiles.d/maxfreq.conf ]] && rm /etc/tmpfiles.d/maxfreq.conf
[[ -f /etc/sysctl.d/99-max_user-watches.conf ]] && rm /etc/sysctl.d/99-max_user-watches.conf
[[ -f /etc/security/limits.conf.bak ]] && mv /etc/security/limits.conf.bak /etc/security/limits.conf
[[ -f /etc/rc.local ]] && sed -i '\|/usr/bin/Sound.sh|d' /etc/rc.local

sudo rm basic-install.sh

border 'Rebooting System'

reboot
