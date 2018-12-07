#!/usr/bin/env bash

# also set the ansible 'vim_version'...
VIM_VERSION=81b

clone() {
  [ -d firecracker-go-sdk ] || git clone https://github.com/firecracker-microvm/firecracker-go-sdk.git
  cd firecracker-go-sdk
}

build() {
  make
}

install() {
  cp cmd/firectl/firectl ../
}

clone && build && install

