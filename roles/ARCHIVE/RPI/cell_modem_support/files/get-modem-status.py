#!/usr/bin/python
import serial
import time
from time import sleep
from datetime import datetime
import os
import sys, getopt

port = "/dev/ttyUSB0"

html=0

ser = serial.Serial(port,  # Device name varies
                     baudrate=115200,
                     bytesize=8,
                     parity='N',
                     stopbits=1,
                     timeout=2)
counter = 0

def get_ati():
    ser.write('ATI\r')
    resp = ser.read(300)
    if html:
        print '<tr><td>Modem model info</td><td bgcolor="#00F000">Good</td><td>', resp, "</td></tr>\r"
    else:
        print "Getting modem data"
        print resp
   
def check_provider_lock():
    ser.write('AT+CPIN?\r')
    resp = ser.readline()
    resp = ser.readline()
    if 'READY' in resp:
        if html:
            print '<tr><td>Probider lock</td><td bgcolor="#00F000">Good</td><td>Not Locked</td></tr>\r'
        else:
            print 'Modem appears to be functional and not provider locked\n'
    else:
        if html:
            print '<tr><td>Probider lock</td><td bgcolor="#F00000">Error</td><td>No data', "\r" 
        else:
            print 'ERROR! Modem appears to be provider locked. CPIN querry was', resp, '\r'
        print 'See <a href=https:wiki.ubuntu.comSierraMC8775>https:wiki.ubuntu.comSierraMC8775</a> for additional info.</td></tr>\r'

def get_signal_strength():
    ser.write('AT+RSCP?\r')
    resp = ser.readline()
    resp = ser.readline()
    resp = ser.readline()
    # RSCP: -98 dBm
    if 'RSCP:' in resp:
        parts = resp.split(" ")
        for part in parts:
            if '-' in part:
                strength = part
        if html:
            # Result color derived from: http://blog.industrialnetworking.com/2014/04/making-sense-of-signal-strengthsignal.html
            if strength > -69:
                color="#00F000"
                sigtext="Execellent"
            if strength > -86 and strength < -70:
                color="#FFFF00"
                sigtext="Good"
            if strength > -100 and strength < -86:
                color="#FFFF00"
                sigtext="Good"
            if strength > -110 and strength < -100:
                color="#FF4500"
                sigtext="Fair"
            if strength < -109:
                color="#8B0000"
                sigtext="Poor"
            print '<tr><td>Signal strength</td><td bgcolor="', color, '">', sigtext, '</td><td>', strength, "</td></tr>\r"
        else:
            print 'Modem signal strength ', strength, "\n"
    else:
        if html:
            print '<tr><td>Signal Strengh</td><td bgcolor="#F00000">Error</td><td>No valid output', "\r" 
        else:
            print 'ERROR! No valid signal strength read from modem', resp, '\r'
        print 'See <a href=https:wiki.ubuntu.comSierraMC8775>https:wiki.ubuntu.comSierraMC8775</a> for additional info.</td></tr>\r'

def output():
    # First, see if a modem is on the port to be used.
    ser.write('AT\r')
    resp = ser.readline()
    resp = ser.readline()
    #resp = ser.read(2)
    #print resp
    if 'OK' in resp:
        if html:
            print '<a>Modem Detected on ', port, '</a>'
        else:
            print 'Modem detected on ', port
    else:
        print 'ERROR, AT finds no modem on ', port
        print resp
        exit(1)
    if html:
#        print "good {background-color: #00ff00;}\r"
#        print "bad {background-color: rgb(255,0,0);}\r"
        print '<table border="1"><tr><td>Item</td><td>Result</td><td>extended</td></tr>', "\n"
    check_provider_lock()
    get_ati()
    get_signal_strength()
    if html:
        print "</table>\r"
    ser.close()

def main(argv):
    inputfile = ''
    outputfile = ''
    try:
        opts, args = getopt.getopt(argv,"hct::",["cli","html"])
    except getopt.GetoptError:
        print 'get-modem-status.py -h --cli --html'
        sys.exit(2)
    for opt, arg in opts:
        if opt == '-h':
            print 'test.py --cli --html'
            sys.exit()
        elif opt in ("-c", "--cli"):
            html=0
        elif opt in ("-t", "--html"):
            global html
            html=1
    output()

if __name__ == "__main__":
       main(sys.argv[1:])

exit(0)
