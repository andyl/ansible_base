#!/usr/bin/env bash

# build erlang on raspbian

# from http://elinux.org/Erlang

otpfile=otp_src_18.0
release=erl18rasp
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
