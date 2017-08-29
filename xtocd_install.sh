#!/bin/sh

INSTALL_PATH=$PWD/xocd/

C_INSTALL_PATH=/usr/src/linux/include

source ./google_drive.sh

FTDI_DRIVER_ARCH=libftd2xx-i386-1.4.6.tgz

if [ ! -e ${FTDI_DRIVER_ARCH} ]; then
  download_file 0BzSl3gduBcnueHBjWDhTVTcyU1E ${FTDI_DRIVER_ARCH}
  tar -xf ${FTDI_DRIVER_ARCH}
  cd release
  sudo cp build/libftd2xx.* /usr/local/bin
  sudo chmod 0755 /usr/local/lib/libftd2xx.so.1.4.6
  sudo ln -sf /usr/local/lib/libftd2xx.so.1.4.6 /usr/local/lib/libftd2xx.so
  cd -
fi


if [ ! -e ${INSTALL_PATH} ]; then 
  echo xt-ocd install $INSTALL_PATH...
  mkdir -p ${INSTALL_PATH}
  cd xtensa/XtDevTools/downloads/RE-2013.3/tools/
  sudo ./xt-ocd-10.0.3-linux-installer --mode unattended --prefix ${INSTALL_PATH}
  cd -
  sudo cp topology.xml ${INSTALL_PATH}
  sudo mv ${INSTALL_PATH}/FTDI ${INSTALL_PATH}/orig-FTDI
  sudo mkdir ${INSTALL_PATH}/FTDI
  sudo cp /usr/local/lib/libftd2xx.so.1.4.6 ${INSTALL_PATH}/FTDI/libftd2xx.so.0
fi


