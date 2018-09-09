#!/usr/bin/env bash

# also set the ansible 'vim_version'...
VIM_VERSION=81b

install() {
  [ -d vim ] || git clone https://github.com/vim/vim.git
  cd vim/src
}

config() {
  make distclean
  ./configure \
    --enable-pythoninterp \
    --enable-rubyinterp \
    --enable-luainterp \
    --enable-gui=no
}

build() {
  make
}

pkg() {
  sudo checkinstall \
    --install=no \
    --maintainer=andy@r210.com \
    --pkgname=vimal \
    --pkgversion=$VIM_VERSION \
    --pkgsource="." \
    --provides=vimal 
}

install && config && build && pkg

