#!/bin/sh
	ipaddr=$(/sbin/ifconfig eth0 | /bin/grep inet\ addr | /bin/sed s/\ \ /:/g | /usr/bin/cut -d: -f7)
	ipaddrwifi=$(/sbin/ifconfig wlan0 | /bin/grep inet\ addr | /bin/sed s/\ \ /:/g | /usr/bin/cut -d: -f7)
	router=$(/sbin/route -n  | /bin/grep ^0.0 | sed s/\ /:/g | /usr/bin/cut -d: -f10)
	desthost=wordpress.michaelgregg.com
	hostname="<hostname>"
	echo "Subject: $hostname Startup
This is the linux machine at $ipaddr
ip addr is $ipaddr, router is $router.
wifi address is $ipaddrwifi .
Tunnel is being opened to $desthost as user $user to port $destport." > /dev/shm/message

/usr/sbin/sendmail home-email < /dev/shm/message

wget http://$desthost/cgi-bin/ip-reporter.cgi --post-data "name=$hostname&ip=$ipaddr&wifi=$ipaddrwifi"

