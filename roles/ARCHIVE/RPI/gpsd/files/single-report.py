#!/usr/bin/python
import gps
 
import sys, time
from socket import *

#serverHost = 'rotate.aprs.net'
serverHost = 'noam.aprs2.net'
#serverPort = 20157
serverPort = 14580
password = '23716'
address = 'KF6WRW-10>APRS,TCPIP*:'
position = '=3700.14N/11000.56W-' # Old position string for reference
# comment length is supposed to be 0 to 43 char.
comment = 'BAMRU Single Shot report.'
packet = ''
delay = 15 # delay in seconds - 15 sec. is for testing- should be 20 to 30 min for fixed QTH

# Listen on port 2947 (gpsd) of localhost
session = gps.gps("localhost", "2947")
session.stream(gps.WATCH_ENABLE | gps.WATCH_NEWSTYLE)
 
#class gpsfloat(infloat):
def gpsfloat(infloat):
#    def __str__(self):
    print("%.2f" % infloat)
    return "%.2f" % infloat 

def send_packet( pposition):
    # create socket & connect to server
    sSock = socket(AF_INET, SOCK_STREAM)
    sSock.connect((serverHost, serverPort))
    # logon
    sSock.send('user KI4MTT pass ' + password + ' vers "KI4MTT Python" \n')
    # send packet
    sSock.send(address + pposition + comment +'\n')
    print("packet sent: " + time.ctime() )
    # close socket -- must be closed to avoidbuffer overflow
    time.sleep(15) # 15 sec. delay
    sSock.shutdown(0)
    sSock.close()

    packet = address + pposition + comment
    print (packet) # prints the packet being sent
    print (len(comment)) # prints the length of the comment part of the packet
#    while 1:
#        send_packet()
#    quit(0)
#        time.sleep(delay)

while True:
    try:
    	report = session.next()
		# Wait for a 'TPV' report and display the current time
		# To see all report data, uncomment the line below
		# print report
        if report['class'] == 'TPV':
            if hasattr(report, 'time'):
                print report.time
		print report
		print dir(report)
		lat = gpsfloat(report.lat * 100)
		if lat > 0:
                    latd = "N"
                else:
                    latd = "S"
                    lat = lat * -1
		lon = gpsfloat(report.lon * 100)
		if lon > 0:
                    lond = "E"
                else:
                    lond = "W"
                    lon = lon * -1
                pposition = "=%s%s/%s%s-" % ( lat, latd, lon, lond )
                print pposition
                # Now we have the position collected properly. Now, report it. 
                while 1:
                    send_packet(pposition)
		quit(0)
    except KeyError:
		pass
    except KeyboardInterrupt:
		quit(0)
    except StopIteration:
		session = None
		print "GPSD has terminated"
		quit(1)
