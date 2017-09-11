# qca4010

## System requirement
###### UBUNTU (14.04)

This packages should be installed:
git, lib32gcc-4.8-dev, lib32stdc++6, lib32z1-dev, libxml2-dev, linux-source, expect


You can intsall it by:

```
sudo apt-get install git lib32gcc-4.8-dev lib32stdc++6 lib32z1-dev libxml2-dev linux-source expect lib32ncurses5-dev
```

###### openSUSE (Leap42.3)

This packages should be installed:
git, gcc-32bit, libxml2-devel, make, kernel-devel, kernel-source, kernel-default-devel, expect

```
sudo zypper in git gcc-32bit libxml2-devel make kernel-devel kernel-source kernel-default-devel expect
```

## Install

Run the *xtensa_build.sh* to build qca4010 firmware.


## Intsall XOCD

If you use a virtual machine probably it will better to install XOCD in your host machine (for the better performance and it helps to avoid usb issues as well)

- Windows

Download the xt-ocd windows installer (https://drive.google.com/open?id=0BzSl3gduBcnucE9GTG9FbklRN0U)
Launch the binary installer and follow for the install wizard.
After succeed installation you can run the XOCD by AllApps->Xtensa OCD Daemon 10.0.3->Xtensa OCD Daemon

- Linux

For xt-ocd installation you should to create /usr/src/linux folder contains kernel source.

###### UBUNTU (14.04)

```
sudo mkdir /usr/src/tmp
sudo tar -xf /usr/src/linux-source-*/linux-source-*.bz2 -C /usr/src/tmp/
sudo mv /usr/src/tmp/linux-source-* /usr/src/linux
sudo rm -rf /usr/src/tmp/
sudo ln -s /usr/src/linux-headers-$(uname -r)/include/generated/utsrelease.h /usr/src/linux/include/linux/
```

###### openSUSE (Leap42.3)

For xt-ocd installation create symbolic link:

```
sudo ln -s /usr/src/linux-*-obj/x86_64/default/include/generated/utsrelease.h /usr/src/linux/include/linux/
```

Run the *xtocd_install.sh* to install XT-OCD daemon

## Flash

If you use a virtual machine and the XOCD daemon was installed on your host system then run XT-OCD Daemon at first (host side).

And define the XOCD and XADDR system variables on the guest machine:

```
export XOCD=no
export XADDR=10.0.2.2
```

when XADDR - **host machine address** where XOCD daemon was launched.

This script captures the debug output till "Device MQTT telemetry" ckecking. After this you may use the minicom command.

The default port is /dev/ttyUSB0. You can change this by command: 
```
export COM=/dev/ttyUSB1
```

If your don't want to test the debug output after flashing a board use
```
export XTEST=no
```

Run the *run_xtensa.sh* to flash the board and run an application
