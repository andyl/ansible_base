#!/bin/sh
if [ ! -f /dev/shm/called-home ]; then
	touch /dev/shm/called-home
	# Tunnel doesn't appear to be connected, reconnecting
	/usr/sbin/ntpdate -s clock.redhat.com &
	sleep 30
	/bin/call-home-script.bash &
fi	
exit 0
