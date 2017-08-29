# qca4010

Run the *xtensa_build.sh* to build qca4010 firmware.


Run the *xtocd_install.sh* to install XT-OCD daemon


Run the *run_xtensa.sh* to flash the board and run an application

The default port is /dev/ttyUSB0. You can change this by command: 
```
export COM=/dev/ttyUSB1
```
This script captures the debug output till "Device MQTT telemetry" ckecking. After this you may use the minicom command.
