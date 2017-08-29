#!/bin/sh

#
# Copyright (c) 2017 Arrow Electronics, Inc.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License 2.0
# which accompanies this distribution, and is available at
# http://apache.org/licenses/LICENSE-2.0
# Contributors: Arrow Electronics, Inc.
#


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
