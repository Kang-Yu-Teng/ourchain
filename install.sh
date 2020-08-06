#!/bin/bash

mkdir build
cd build
sudo ../autogen.sh
sudo ../configure --without-gui --disable-tests  CXXFLAGS="-O0 -g" CFLAGS="-O0 -g" 
#sudo ../configure --without-gui --disable-tests  CXXFLAGS="-g" CFLAGS="-g" 
sudo rm -rf ~/.bitcoin
sudo make -j8
sudo make install 
sudo ldconfig
