# qca4010

## System requirement
###### UBUNTU (14.04)

This packages should be installed:
git, lib32gcc-4.8-dev, lib32stdc++6, lib32z1-dev, libxml2-dev, linux-source


You can intsall it by:

```
sudo apt-get install git lib32gcc-4.8-dev lib32stdc++6 lib32z1-dev libxml2-dev linux-source
```

For xt-ocd installation you should to create /usr/src/linux folder contains kernel source.

```
sudo mkdir /usr/src/tmp
sudo tar -xf /usr/src/linux-source-*/linux-source-*.bz2 -C /usr/src/tmp/
sudo mv /usr/src/tmp/linux-source-* /usr/src/linux
sudo rm -rf /usr/src/tmp/
sudo ln -s /usr/src/linux-headers-$(uname -r)/include/generated/utsrelease.h /usr/src/linux/include/linux/
```

###### openSUSE (Leap42.3)

This packages should be installed:
git, gcc-32bit, libxml2-devel, make, kernel-devel, kernel-source, kernel-default-devel

```
sudo zypper in git gcc-32bit libxml2-devel make kernel-devel kernel-source kernel-default-devel
```

For xt-ocd installation create symbolic link:

```
sudo ln -s /usr/src/linux-*-obj/x86_64/default/include/generated/utsrelease.h /usr/src/linux/include/linux/
```

## Install

Run the *xtensa_build.sh* to build qca4010 firmware.


Run the *xtocd_install.sh* to install XT-OCD daemon

## Flash

Run the *run_xtensa.sh* to flash the board and run an application

The default port is /dev/ttyUSB0. You can change this by command: 
```
export COM=/dev/ttyUSB1
```
This script captures the debug output till "Device MQTT telemetry" ckecking. After this you may use the minicom command.
