#!/bin/bash
# This script gathers info about a gps device, then writes info to the udev rules to make that device always connect to /dev/ttyUSBGPS

rulesFile="/etc/udev/rules.d/90-gpsd.rules"
udevTemplate='SUBSYSTEM=="tty", ATTRS{idVendor}=="-vendorid-", ATTRS{idProduct}=="-productid-", ATTRS{serial}=="-serial-", SYMLINK+="ttyUSBGPS"'

sleepTime=1

# Must be run as root
whoami | grep root > /dev/null 
if [ $? -ne 0 ]; then
	echo "ERROR - must be run as root."
	exit 1;
fi

# Display help section if -h or -? is specified
show_help()
{
	echo "usage: $0 <options>"
	echo 'Avaliable options:
	-h : Display this help
	-n 1 : Non-interactive mode. Requires -V -P and -S
	-V : Vendor ID
	-P : Product ID
	-S : Serial number
	-v : Verbose output
	-f : Force writing config if is has already been set.'
	echo ""
	echo "  Example : $0 -n 1 -V 0403 -S 6001 -S A1019F8F -f" 
}

# Comment out everything in $rulesFile 
clear_config()
{
	if [ $verbose -eq 1 ]; then
		echo "Clear Config"
	fi
	touch $rulesFile
	# Replace all line startings with a #
	sed -i s/^/#/g $rulesFile
	# Clean out double #'s
	sed -i s/^##/#/g $rulesFile
}

# Write new udev rules to $rulesFile
write_udev_rules()
{
#	udevTemplate='SUBSYSTEM==4tty4, ATTRS{idVendor}==4-vendorid-4, ATTRS{idProduct}==4-productid-4, ATTRS{serial}==4-serial-4, SYMLINK+=4ttyUSBGPS4'
	newUdev=$(echo $udevTemplate | sed s/-vendorid-/$vendor/g | sed s/-productid-/$product/g | sed s/-serial-/$serial/g)
	if [ $verbose -eq 1 ]; then
		echo "New Udev rule line is: "
		echo $newUdev
	fi
	echo 'KERNEL=="ttyACM[0-19]*", MODE="0777"' >> $rulesFile
	echo 'KERNEL=="ttyUSB[0-19]*", MODE="0777"' >> $rulesFile
	echo $newUdev >> $rulesFile
}

# Restart gpsd service
restart_gpsd()
{
	echo "Restarting gpsd"
	/usr/sbin/service gpsd restart
	/etc/init.d/gpsd restart
}

# Restart udev service
restart_udev()
{
	echo "Restarting Udev"
	/usr/sbin/service udev restart
	/etc/init.d/udev restart
	restart_gpsd
}

# Prompt user to unplug the GPS device
prompt_unplug_device()
{
	echo ""
	echo "Please unplug the USB GPS and hit enter."
	echo ""
	read ll
	echo "Sleeping $sleepTime seconds to wait for usb devices to settle"
	sleep $sleepTime
	deviceCount=$(lsusb | cut -d\  -f 6| wc -l)
	count=0
	echo "export preDeviceCount=$deviceCount" > /dev/shm/tempvars.bash
	lsusb | cut -d\  -f 6 | while read devices; do
		cmd="export dev$count='$devices'"
		echo $cmd >> /dev/shm/tempvars.bash
		if [ $verbose -eq 1 ]; then echo "evaluating $cmd"; fi
		eval $cmd
		let count=$count+1
	done
	echo "Number of devices detected is $deviceCount"
	source /dev/shm/tempvars.bash
}

# Prompt user to plug back in the GPS device
prompt_plug_in_device()
{
	echo ""
	echo "Please plug back in the device and hit enter."
	echo ""
	read ll
	echo "Sleeping $sleepTime seconds to wait for usb devices to settle"
	sleep $sleepTime
	deviceCount=$(lsusb | cut -d\  -f 6| wc -l)
	count=0
	echo "export lateDeviceCount=$deviceCount" >> /dev/shm/tempvars.bash
	lsusb | cut -d\  -f 6 | while read devices; do
		cmd="export latedev$count='$devices'"
		echo $cmd >> /dev/shm/tempvars.bash
		if [ $verbose -eq 1 ]; then echo "evaluating $cmd"; fi
		eval $cmd
		let count=$count+1
	done
	source /dev/shm/tempvars.bash
	echo "Number of devices detected is $lateDeviceCount"
	if [ $preDeviceCount -eq $lateDeviceCount ]; then
		echo ""
		echo "ERROR - Device count unchanged, did you uplug it, then reinsert it?"
		echo ""
		exit 1
	fi
}

# Use the serial number gathered from the previous step.
use_serial_number()
{
	if [ ! -f /dev/shm/usbtouse ]; then
		echo "Error, /dev/shm/usbtouse not found"
		exit 1
	fi
	devToCheck=$(cat /dev/shm/usbtouse)
	vendorToCheck=$(echo $devToCheck | cut -d: -f1)
	modelToCheck=$(echo $devToCheck | cut -d: -f2)
	find /dev | grep tty| while read testdev; do
		export vendor=$(/sbin/udevadm info --name=$testdev --query=all | grep ID_VENDOR_ID | cut -d= -f2)
		export product=$(/sbin/udevadm info --name=$testdev --query=all | grep ID_MODEL_ID | cut -d= -f2)
		export serial=$(/sbin/udevadm info --name=$testdev --query=all | grep ID_SERIAL_SHORT | cut -d= -f2)
		if [ "$vendorToCheck" == "$vendor" ] && [ "$modelToCheck" == "$product" ]; then
			echo ""
			echo "Match found on $testdev"
			echo "Serial number found as $Serial"
			echo "Write $rulesFile with this info?"
			echo "y/n?"
			read value
			echo $value | grep y &> /dev/null
			if [ $? -ne 0 ]; then
				echo "NOTICE - Exiting"
				exit 1;
			else 
				echo "Yes read, continuing."
				clear_config
				write_udev_rules
				restart_udev
				exit 0
			fi
			exit 0
		fi 
	done
}

# Take the usb product and device ID's, and extract a serial number from it.
gather_serial_number()
{
	source /dev/shm/tempvars.bash	
	count=0
	let end=$preDeviceCount+1
	while [ $count -lt $end ]; do
		cmd="pre=\$dev$count"
		eval $cmd
		cmd="post=\$latedev$count"
		eval $cmd
		if [ $verbose -eq 1 ]; then echo pre=$pre; fi
		if [ $verbose -eq 1 ]; then echo post=$post; fi
		echo $pre | grep $post &> /dev/null
		if [ $? -ne 0 ]; then
			echo ""
			echo "Device $post not found in output list."
			echo ""
			lsusb | grep $post
			echo "Run on this device?"
			echo "y/n?"
			read value
			echo $value | grep y &> /dev/null
			if [ $? -ne 0 ]; then
				echo "NOTICE - Exiting"
				exit 0;
			else 
				echo "Yes read, continuing."
				echo $post > /dev/shm/usbtouse
				use_serial_number
				exit 0
			fi

		fi
		let count=$count+1
	done
}

OPTIND=1         # Reset in case getopts has been used previously in the shell.

# Initilize some variables for later use.
verbose=0
interactive=1
force=0

while getopts "h?vfn:V:P:S:l" opt; do
    case "$opt" in
    h|\?)
        show_help
        exit 0
        ;;
    n)  interactive=0
	;;
    V)  vendor=$OPTARG
	;;
    P)  product=$OPTARG
	;;
    S)  serial=$OPTARG
	;;
    v)  verbose=1
        ;;
    f)  force=1
        ;;
    esac
done

if [ -f /etc/gpsd/usbdev ] && [ $interactive -eq 1 ]; then
	echo ""
	echo "NOTICE - Setup has already been executed."
	echo "  Would you like to overwrite any previous config?"
	echo "  y - Yes"
	echo "  n - No"
	read value
	echo $value | grep y &> /dev/null
	if [ $? -ne 0 ]; then
		echo "NOTICE - Aborting"
		exit 0;
	else 
		echo "Yes read, continuing."
		echo ""
	fi
fi

# Check to ensure that all bash options are set for non-interactive mode to work.
if [ $interactive -eq 0 ]; then 
	if [ $verbose -eq 1 ]; then echo "Non-interactive mode"; fi
	if [ ! -n $vendor ] || [ ! -n $product ] || [ ! -n $serial ]; then
		echo "ERROR - Non interactive mode called without specifying all of these options"
		echo "	-V - four digit vendor id of usb dev"
		echo "	-P - four digit product id of usb dev"
		echo "	-S - Serial number of USB device to use"
	else
		echo "Map usb device to /dev/ttyUSBGPS using the following values:"
		echo "Vendor ID = $vendor"
		echo "Product ID = $product"
		echo "Serial Num = $serial"
		clear_config
		write_udev_rules
		restart_udev
	fi
else
	if [ $verbose -eq 1 ]; then echo "Interactive mode"; fi
	prompt_unplug_device
	prompt_plug_in_device
	gather_serial_number
fi 

