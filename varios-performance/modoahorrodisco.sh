#!/bin/bash
hdparm -B 1 -S 12 /dev/sda
echo "Velocidad del disco reducida y APM activado"
