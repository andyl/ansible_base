#!/usr/bin/env bash

# compile tmux - https://tmux.github.io
 
[[ "$#" == "0" ]] && echo "Usage: CompileTmux.sh <version>" && exit 1

TVSN=$1
TDIR=tmux-$TVSN
DEST=tmux-$(uname -m)-$TVSN

# ----- start with a fresh directory -----
rm -rf $TDIR
mkdir $TDIR

cd $TDIR

# ----- get the release and unpack it -----
wget https://github.com/tmux/tmux/releases/download/$TVSN/tmux-$TVSN.tar.gz
tar xf tmux-$TVSN.tar.gz
cd tmux-$TVSN

# ----- compile and save the executable -----
./configure && make
cp tmux ../../$DEST

# ----- clean up -----
cd ../..
rm -rf tmux-$TVSN

echo -------------------------------------------------------------------
echo created $DEST
