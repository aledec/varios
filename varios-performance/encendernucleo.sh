#!/bin/bash
echo 1 | tee /sys/devices/system/cpu/cpu1/online
echo 1 | tee /sys/devices/system/cpu/cpu2/online
echo 1 | tee /sys/devices/system/cpu/cpu3/online

echo "Nucleo N\1 encendido"
~
