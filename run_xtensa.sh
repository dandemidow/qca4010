#!/bin/bash

#
# Copyright (c) 2017 Arrow Electronics, Inc.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License 2.0
# which accompanies this distribution, and is available at
# http://apache.org/licenses/LICENSE-2.0
# Contributors: Arrow Electronics, Inc.
#


COM=${COM:-/dev/ttyUSB0}
XTEST=${XTEST:-yes}
XOCD=${XOCD:-yes}
XADDR=${XADDR:-127.0.0.1}

echo "*****************************************"
echo -e "* use xt-ocd daemon \t${XOCD}\t\t*"
echo -e "* xt-ocd address\t${XADDR}\t*"
echo -e "* use debug test\t${XTEST}\t\t*"
echo -e "* default serial\t${COM}\t*"
echo "*****************************************"

if [ ${XOCD} == yes ]; then
  ftdi_mod=$(lsmod | grep ftdi_sio)
  if [ ! -z "$ftdi_mod" ]; then 
    sudo rmmod ftdi_sio
  fi
#  usbserial=$(lsmod | grep usbserial)
#  if [ ! -z $usbserial_mod ]; then 
#    sudo rmmod usbserial
#  fi
fi

export MAIN_PATH=$PWD
cd 4010.tx.1.1_sdk/target

export TARGET_PATH=$PWD
source ./xtensa_env.sh
source ./sdkenv.sh

cd -
if [ ${XTEST} == yes ]; then
sudo chmod a+wr $COM
fi
./run_xtensa.exp $COM $XOCD $XADDR $XTEST
