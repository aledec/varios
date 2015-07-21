#!/bin/ksh
HOSTFILE=/etc/hosts
PRINTERFILE=/etc/hosts.printers
ACTUALDATE=`date +%Y%m%d%H%M`

#Substract strings containing printer definition 
sed '/## INICIO Definicion de impresoras/,/## FIN Definicion de impresoras/!d'i $HOSTFILE > $PRINTERFILE

if [ $(wc -l $PRINTERFILE) -lt 2) ]; then
	echo "Error en la generacion del fichero hosts"
	exit 1
fi

#copy file server
./rsync_update_hosts.sh
if [ $? -ne 0 ]; then
	echo "Error en la copia del fichero hosts"
	exit 1
fi

#Execute update sed
#ssh replace file sed
