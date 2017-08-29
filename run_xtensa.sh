#!/bin/sh

COM=${COM:-/dev/ttyUSB0}

ftdi_mod=$(lsmod | grep ftdi_sio)
if [ $ftdi_mod ]; then 
  sudo rmmod ftdi_sio
fi
usbserial=$(lsmod | grep usbserial)
if [ $usbserial_mod ]; then 
  sudo rmmod usbserial
fi

export MAIN_PATH=$PWD
cd 4010.tx.1.1_sdk/target

export TARGET_PATH=$PWD
source ./xtensa_env.sh
source ./sdkenv.sh

cd -
sudo chmod a+wr $COM
./run_xtensa.exp $COM
