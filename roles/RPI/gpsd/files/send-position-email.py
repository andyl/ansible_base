#!/usr/bin/python
import gps
 
import sys, time, re, datetime, getopt
from time import gmtime, strftime
from socket import *
import smtplib
from smtplib import SMTPException

# Example google URL
# https://maps.google.com/maps?ll=37.405701,-122.325119&q=37.405701,-122.325119&hl=en&t=m&z=15
# https://maps.google.com/maps?ll=3739.777094,-12189.419480&q=3739.777094,-12189.419480&hl=en&t=m&z=15
# List format
# <dictwrapper: {u'epx': 19.292, u'epy': 53.729, u'track': 187.4815, u'ept': 0.005, u'lon': -121.98132359, u'eps': 0.3, u'lat': 37.319331555, u'tag': u'MID2', u'mode': 2, u'time': u'2015-09-11T07:34:32.000Z', u'device': u'/dev/ttyUSB0', u'speed': 0.612, u'class': u'TPV'}>
#['__contains__', '__doc__', '__getitem__', '__init__', '__module__', '__repr__', '__setitem__', '__str__', u'class', u'device', u'eps', u'ept', u'epx', u'epy', 'get', 'keys', u'lat', u'lon', u'mode', u'speed', u'tag', u'time', u'track']# 
 
#class gpsfloat(infloat):
def gpsfloat(infloat):
#    def __str__(self):
    print("%.6f" % infloat)
    return "%.6f" % infloat 

# Listen on port 2947 (gpsd) of localhost
#session = gps.gps("localhost", "2947")
#session.stream(gps.WATCH_ENABLE | gps.WATCH_NEWSTYLE)

sender = 'mgregg@michaelgregg.com'

def send_email(lat, lon, sender, receiver, speed, time):
    try:
        message = """From: From BAMRU Truck <--sender-->
To: To Person <--to-->
Subject: BAMRU truck SMTP e-mail test position
Mime-Version: 1.0;
Content-Type: text/html; charset="ISO-8859-1";
Content-Transfer-Encoding: 7bit;
<html>
<body>

Current position is <a href="https://maps.google.com/maps?ll=--lat--,--lon--&q=--lat--,--lon--&hl=en&t=m&z=15">-Location-</a>

<br>Current position: --lat--, --lon--
<br>Current speed: --speed-- (mpg, furlongs per fortnight, IDK...)
<br>GPS Time(gmt): --time--
<br>System Time: --systime-- 

<br>This is a test e-mail message.
</body>
</html>
"""
        message = re.sub(r"--sender--", sender, message)
        message = re.sub(r"--to--", receiver, message)
        message = re.sub(r"--lat--", lat, message)
        message = re.sub(r"--lon--", lon, message)
        message = re.sub(r"--speed--", gpsfloat(speed), message)
        message = re.sub(r"--time--", time, message)
        message = re.sub(r"--systime--", strftime("%Y-%m-%d %H:%M:%S"), message)
        smtpObj = smtplib.SMTP('localhost')
        smtpObj.sendmail(sender, receiver, message)         
        print "Successfully sent email"
	exit(0)
    except SMTPException:
        print "Error: unable to send email"

def main(argv):
    # Listen on port 2947 (gpsd) of localhost
    session = gps.gps("localhost", "2947")
    session.stream(gps.WATCH_ENABLE | gps.WATCH_NEWSTYLE)
    email = ''
    try:
       opts, args = getopt.getopt(argv,"e:o:",["email="])
    except getopt.GetoptError:
       print 'send-position-email.py -e <email to send to>'
       sys.exit(2)
    for opt, arg in opts:
       if opt == '-h':
          print 'send-position-email.py -e <email to send to'
          sys.exit()
       elif opt in ("-e", "--email"):
          email = arg
    print 'email is "', email
    if email == '':
        print 'send-position-email.py -e <email to send to>'
        exit(1)
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
                    lat = gpsfloat(report.lat)
                    lon = gpsfloat(report.lon)
#                pposition = "=%s%s/%s%s-" % ( lat, latd, lon, lond )
#                print pposition
                # Now we have the position collected properly. Now, report it. 
                while 1:
                    send_email(lat, lon, sender, email, report.speed, report.time)
		quit(0)
        except KeyError:
		pass
        except KeyboardInterrupt:
		quit(0)
        except StopIteration:
		session = None
		print "GPSD has terminated"
		quit(1)

if __name__ == "__main__":
    main(sys.argv[1:])

