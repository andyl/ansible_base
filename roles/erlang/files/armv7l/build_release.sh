#!/usr/bin/env bash

# build erlang on armv7l (32-bit RPi/Raspbian and Odroid XU4)

# from http://elinux.org/Erlang

# TO USE:
# 1) copy the script to a build machine, and run it
# 2) save the release image to the current directory 
#    x-ansible/roles/erlang/files/armv7l/<release_image>

version=18.3
otpfile=otp_src_$version
release=erl_armv7l_$version
rel_dir=`pwd`/$release
rel_tar=$release.tar.gz

sudo apt-get update
sudo apt-get install wget
sudo apt-get install libssl-dev
sudo apt-get install ncurses-dev
sudo apt-get install m4
wget http://www.erlang.org/download/$otpfile.tar.gz
mkdir -p $rel_dir
tar -xzvf $otpfile.tar.gz
cd $otpfile
./configure
make
make install DESTDIR=$rel_dir
cd ..
tar cfz $rel_tar $release
echo "MAKE && MAKE RELEASE - DONE"
echo "RELEASE IMAGE IS $rel_tar"
