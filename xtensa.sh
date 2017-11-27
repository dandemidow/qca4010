#!/bin/bash

#
# Copyright (c) 2017 Arrow Electronics, Inc.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License 2.0
# which accompanies this distribution, and is available at
# http://apache.org/licenses/LICENSE-2.0
# Contributors: Arrow Electronics, Inc.
#


### SET THIS VARIABLE!
XPLORER_PATH=$PWD/xtensa
#XPLORER=1
### END
source ./google_drive.sh

usage()
{
cat << XTENSA_USAGE

Options:

build
    Build the Arrow firmware for QCA4010

rebuild
    Clean and build the firmware again

private
    View and edit the private.h file

up
    Update the asn-sdk-c and acn-embedded repositories

flash
    Flash the new firmware into a QCA board 
XTENSA_USAGE
}

### Main function ###
# clear cookies
[ -e c.f ] && rm c.f 

[ ! -e private.h ] && { echo "Put the private.h file into current directory" && exit 1; }

if [ -e /usr/include/libxml2 ]; then
  if [ ! -e /usr/include/libxml ]; then
    echo "ln -s /usr/include/libxml2 /usr/include/libxml"
  fi
fi
cat > test_xml.c << EOF
#include <libxml2/libxml/parser.h>
int main() { return 0; }
EOF

gcc -o test_xml test_xml.c -I/usr/include/libxml2 || { echo "There is no libxml2" && exit 1; }
rm test_xml*

if [ ! -e /lib/ld-linux.so.2 ]; then
  echo "There are no 32bit libraries; Please install"
  echo "(for Ubuntu: sudo apt-get install libc6-i386)"
  exit 1;
fi

XPLORER_INSTALLER_BASE=Xplorer-5.0.3-linux-installer
XPLORER_INSTALLER_BIN=${XPLORER_INSTALLER_BASE}.bin

if [ ! -e ${XPLORER_INSTALLER_BIN} ]; then
  download_big_file 0BzSl3gduBcnuZnR3ZVVCWWdyZTQ ${XPLORER_INSTALLER_BIN} || { echo "cannot download ${XPLORER_INSTALLER_BIN}" && exit 1; }
  chmod a+x ${XPLORER_INSTALLER_BIN}
fi
if [ ! -e ${XPLORER_PATH}/XtDevTools/install/builds/ ]; then
  ./${XPLORER_INSTALLER_BIN} --mode unattended --prefix ${XPLORER_PATH} || { echo "cannot run the ${XPLORER_INSTALLER_BIN}" && exit 1; }
  if [ ! -e ${XPLORER_PATH}/XtDevTools/install/builds/ ]; then
    echo "${XPLORER_INSTALLER_BIN} something goes wrong";
    exit 1;
  fi
fi


if [ ! -e license.dat ]; then
  download_file 0BzSl3gduBcnuZEROQVZuRVQ1Vnc license.dat || { echo "cannot download license.dat" && exit 1; }
  cp license.dat ~;
fi

KF_LINUX=KF_2013_3_linux.tgz
if [ ! -e ${KF_LINUX} ]; then
  download_file 0BzSl3gduBcnuTXVocGUxUERCb00 ${KF_LINUX}
fi

if [ ! -e ${XPLORER_PATH}/XtDevTools/install/builds/RE-2013.3-linux/KF/ ]; then 
  tar -xf ${KF_LINUX} -C ${XPLORER_PATH}/XtDevTools/install/builds/ || { echo "${KF_LINUX} error" && exit 1; }
  cd ${XPLORER_PATH}/XtDevTools/install/builds/RE-2013.3-linux/KF/
  ./install --xtensa-tools ${XPLORER_PATH}/XtDevTools/install/tools/RE-2013.3-linux/XtensaTools/ --registry ${XPLORER_PATH}/XtDevTools/XtensaRegistry/
  cd -
fi

if [ $XPLORER ]; then
  echo run ${XPLORER_PATH}/Xplorer-5.0.3/xplorer
  cd ${XPLORER_PATH}/Xplorer-5.0.3
  ./xplorer
  cd -
fi

if [ ! -e xtensa_env.sh ]; then
cat > xtensa_env.sh << EOF
export XTENSA_INST=${XPLORER_PATH}
export XTENSA_CORE=KF
export XTENSA_ROOT=\$XTENSA_INST/XtDevTools/install/builds/RE-2013.3-linux/KF
export XTENSA_SYSTEM=\$XTENSA_ROOT/config
export XTENSA_TOOLS_ROOT=\$XTENSA_INST/XtDevTools/install/tools/RE-2013.3-linux/XtensaTools
export LM_LICENSE_FILE=~/license.dat
export PATH=\$PATH:\$XTENSA_TOOLS_ROOT/bin
EOF
chmod a+x xtensa_env.sh
# mv xtensa_env.sh 
fi

QCA_ARCH=qca4010.tx_.2.1_qdn.tgz
if [ ! -e ${QCA_ARCH} ]; then
  download_big_file 1jn3KVCw9EXLQfJyf4oE2fwBvsAnph6Fy ${QCA_ARCH}
fi 
QCA_SDK_PATH=QCA4010.TX.2.1_QDN
if [ ! -e ${QCA_SDK_PATH} ]; then
  tar -xf ${QCA_ARCH}
  mv xtensa_env.sh ${QCA_SDK_PATH}/target/
  sed "s/-objdump/-xt-objdump/" -i ${QCA_SDK_PATH}/target/demo/sdk_flash/make_flash_hostless.sh
  sed "s/-obj/-xt-obj/g" -i ${QCA_SDK_PATH}/target/tool/makeseg.sh
  # sed "s/^typedef.*size_t;/\#include <qcom\/stdint.h>/" -i 4010.tx.1.1_sdk/target/include/json.h
fi


### clone repo
PRIVATE_FILE=${PWD}/private.h
cd ${QCA_SDK_PATH}/target/
source ./xtensa_env.sh
source ./sdkenv.sh

SILEX_PATH=acn-embedded/silex

if [ ! -e acn-embedded ]; then 
  git clone https://github.com/arrow-acs/acn-embedded.git --recursive
  cp ${SILEX_PATH}/config/libjson.a ./lib/
  cp ${SILEX_PATH}/config/index.html ./demo/sdk_flash/
  cat ${SILEX_PATH}/config/tunable_input.txt | sed 's@\/home\/somebody\/Arrow\/QCA\/4010.tx.1.1_sdk\/target@'"$SDK_ROOT"'@g' > ./tool/tunable/tunable_input.txt
  ln -s ${PRIVATE_FILE} acn-embedded/acn-sdk-c/
fi

source ./xtensa_env.sh
source ./sdkenv.sh
cd ${SILEX_PATH}
case "$1" in 
"private")
less ../acn-sdk-c/private.h
exit 0;
;;
"rebuild")
{ make clean && make; } || { echo "Compilation error" && exit 1; }
;;
"build")
make || { echo "Compilation error" && exit 1; }
;;
"up")
  cd ../acn-sdk-c
  git pull origin master
  cd -
  git pull origin master
;;
"flash")
cd ../../../../
./run_xtensa.sh
;;
*)
usage
;;
esac 

