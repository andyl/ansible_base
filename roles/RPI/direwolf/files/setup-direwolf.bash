#!/bin/bash

direwolfbz="/opt/direwolf-1.2.tar.bz"

if [ ! -f $direwolfbz ]; then
	echo "Error! $direwolfbz not found.";
	exit 1;
fi

if [ -f /etc/direwolf.conf ]; then
	echo "direwolf already appears to be built. Not building."
	exit 0;
fi

rm -f /opt/direwolf-1.2;
cd /opt;
tar xvfj $direwolfbz;
if [ $? -ne 0 ]; then
	echo "Error! decompress of $direwolfbz failed";
	exit 1;
fi

cd /opt/direwolf-1.2;

#make -f Makefile.linux clean
#if [ $? -ne 0 ] ; then
#	echo "Error! make clean failed";
#	exit 1;
#fi

make -f Makefile.linux -j4
if [ $? -ne 0 ]; then
	echo "Error! Make failed";
	exit 1;
fi
make -f Makefile.linux install
if [ $? -ne 0 ]; then
	echo "Error! Make install failed";
	exit 1;
fi
