#!/bin/bash

architecture=$(uname -a)
cpus=$(cat /proc/cpuinfo | grep processor | wc -l)
vcpus=$(cat /proc/cpuinfo | grep processor | wc -l)
memused=$(free -m | grep Mem | awk '{printf "#Memory Usage: %s/%sMB (%.2f)",$3,$2,$3*100/$2}')
diskused=$(df -h | awk '$NF=="/"{printf "#Disk Usage: %d/%dGB (%s)",$3,$2,$5}')
cpuload=$(top -bn1 | grep load | awk '{printf "#CPU Load: %.2f", $(NF-2)}')
lastboot=$(who -b | awk '{printf "#Last boot: %s %s %s", $3,$4,$5}')
lvmuse=$(if [ $(lsblk | grep lvm | wc -l) -eq 0 ]; then echo "No"; else echo "Yes"; fi)
tcpcon=$(ss -s | awk '/TCP:/ {printf "#Connections TCP: %d ESTABLISHED",$2}')
userlog=$(who | cut -d" " -f1 | sort | uniq | wc -l)

netip=$(hostname -I)
netmac=$(ip link | awk '/ether/ {print $2}')
sudo=$(grep 'sudo ' /var/log/sudo/sudo.log | wc -l)

wall '#Architecture: '$arch$'\n'\
	'#CPU physical: '$cpus$'\n'\
	'#vCPU: '$vcpus$'\n'\
	$memused$'\n'\
	$diskused$'\n'\
	$cpuload$'\n'\
	$lastboot$'\n'\
	'#LVM use: '$lvmuse$'\n'\
	$tcpcon$'\n'\
	'#User log: '$userlog$'\n'\
	'#Network: IP '$netip'('$netmac')'$'\n'\
	'#Sudo: '$sudo' cmd'

# minute hour day(month) month day(week) command
# sudo crontab -u root -e
# */10 * * * * /usr/local/bin/monitoring.sh
# @reboot /usr/local/bin/monitoring.sh
