# Installing and configuring gpsd 

This module is tested to work with this sort of reciever:

http://www.amazon.com/GlobalSat-BU-353-S4-USB-Receiver-Black/dp/B008200LHW

It should work with most sirf III and sirf IV USB recievers

This will also work with a generic NMEA output gps with a ftdi hooked to them.

## Setting the USB device of the new GPS.

1. Logon to the pi. 
2. As root, or through sudo, run "sudo setup-usb-gps.bash" 
3. Follow the instructions. Assuming everything goes well, your config should get saved in
    /etc/udev/rules.d/90-gpsd.rules"
4. Unplug your GPS
5. Replug it back in. 
6. ensure that /dev/ttyUSBGPS exists.
7. To test that you have connectivity to the GPS device, run minicom:
    sudo minicom  -b 9600 -D /dev/ttyUSBGPS
    or:
    sudo minicom  -b 57600 -D /dev/ttyUSBGPS
8. Otherwise, as any user run "gpspipe -w"
    if it's working, you should see a bunch of gps sort of data going by.
9. Restart gpsd
    sudo /etc/init.d/gpsd restart
