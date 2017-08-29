#!/bin/sh

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


### Main function ###
# clear cookies
[ -e c.f ] && rm c.f 

[ ! -e private.h ] && { echo "Put the private.h file into current directory" && exit 1; }

cat > test_xml.c << EOF
#include <libxml2/libxml/parser.h>
int main() { return 0; }
EOF

gcc -o test_xml test_xml.c || { echo "There is no libxml2" && exit 1; }
rm test_xml*


XPLORER_INSTALLER_BASE=Xplorer-5.0.3-linux-installer
XPLORER_INSTALLER_BIN=${XPLORER_INSTALLER_BASE}.bin

if [ ! -e ${XPLORER_INSTALLER_BIN} ]; then
  download_big_file 0BzSl3gduBcnuZnR3ZVVCWWdyZTQ ${XPLORER_INSTALLER_BIN}
  chmod a+x ${XPLORER_INSTALLER_BIN}
  ./${XPLORER_INSTALLER_BIN} --mode unattended --prefix ${XPLORER_PATH}
fi


if [ ! -e license.dat ]; then
  download_file 0BzSl3gduBcnuZEROQVZuRVQ1Vnc license.dat
  cp license.dat ~
fi

KF_LINUX=KF_2013_3_linux.tgz
if [ ! -e ${KF_LINUX} ]; then
  download_file 0BzSl3gduBcnuTXVocGUxUERCb00 ${KF_LINUX}
  tar -xf KF_2013_3_linux.tgz -C ${XPLORER_PATH}/XtDevTools/install/builds/
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

QCA_ARCH=14apr_qca4010.tx_.1.1_4.0.1.24.tgz
if [ ! -e ${QCA_ARCH} ]; then
  download_file 0BzSl3gduBcnubGRQRkViSTBaak0 ${QCA_ARCH}
  tar -xf ${QCA_ARCH}
  mv xtensa_env.sh 4010.tx.1.1_sdk/target/
  sed "s/-objdump/-xt-objdump/" -i 4010.tx.1.1_sdk/target/demo/sdk_flash/make_flash_hostless.sh
  sed "s/-obj/-xt-obj/g" -i 4010.tx.1.1_sdk/target/tool/makeseg.sh
  sed "s/^typedef.*size_t;/\#include <qcom\/stdint.h>/" -i 4010.tx.1.1_sdk/target/include/json.h
fi


### clone repo
PRIVATE_FILE=${PWD}/private.h
cd 4010.tx.1.1_sdk/target/
source ./xtensa_env.sh
source ./sdkenv.sh

if [ ! -e acn-embedded ]; then 
  git clone https://github.com/arrow-acs/acn-embedded.git --depth 1 --recursive
  cp acn-embedded/xtensa/config/libjson.a ./lib/
  cp acn-embedded/xtensa/config/index.html ./demo/sdk_flash/
  cat acn-embedded/xtensa/config/tunable_input.txt | sed 's@\/home\/somebody\/Arrow\/QCA\/4010.tx.1.1_sdk\/target@'"$SDK_ROOT"'@g' > ./tool/tunable/tunable_input.txt
  cp ${PRIVATE_FILE} acn-embedded/acn-sdk-c/
fi

source ./xtensa_env.sh
source ./sdkenv.sh
echo $INTERNALDIR 
echo $FW
cd acn-embedded/xtensa
make || { echo "Compilation error" && exit 1; }
