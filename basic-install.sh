#!/bin/bash

border()
{
    local title="| $1 |"
    local edge=${title//?/-}
    echo -e "${edge}\n${title}\n${edge}"
    sleep 1
}

border 'Downloading Sound File'

wget https://github.com/zamiere/Linux-Audio-Adjustments/raw/master/Sound.sh -O /usr/bin/Sound.sh
chmod 755 /usr/bin/Sound.sh

border 'Increasing Sound Group Priority'

[[ -f /etc/security/limits.conf ]] && mv /etc/security/limits.conf /etc/security/limits.conf.bak
echo '#New Limits' > /etc/security/limits.conf
echo '@audio - rtprio 99' >> /etc/security/limits.conf
echo '@audio - memlock 512000' >> /etc/security/limits.conf
#echo '@audio - nice -20' >> /etc/security/limits.conf

border 'Improving Network Latency'

echo "#New Network Latency" > /etc/sysctl.d/network-latency.conf
echo 'net.core.rmem_max = 16777216' >> /etc/sysctl.d/network-latency.conf
echo 'net.core.wmem_max = 16777216' >> /etc/sysctl.d/network-latency.conf

border 'Hardware Timers'

echo 'KERNEL=="rtc0", GROUP="audio"' >> /etc/udev/rules.d/40-timer-permissions.rules
echo 'KERNEL=="hpet", GROUP="audio"' >> /etc/udev/rules.d/40-timer-permissions.rules

border 'Set max user frequency'

echo 'w    /sys/class/rtc/rtc0/max_user_freq     -    -    -    -   3072' >> /etc/tmpfiles.d/maxfreq.conf

border 'Max user watches'

echo 'fs.inotify.max_user_watches = 524288' >> /etc/sysctl.d/99-max_user-watches.conf

border 'Creating System Service'

[[ -f /etc/rc.local ]] || echo -e '#/bin/bash\n\nexit 0' > /etc/rc.local
grep -q '/usr/bin/Sound.sh' /etc/rc.local || sed -i '\|^#!/bin/.*sh|a\/usr/bin/Sound.sh' /etc/rc.local
chmod +x /etc/rc.local
#systemctl enable rc-local || systemctl enable rc.local

border 'Rebooting System'


reboot
