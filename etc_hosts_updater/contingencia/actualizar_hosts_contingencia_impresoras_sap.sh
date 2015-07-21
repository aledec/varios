#!/bin/ksh
HOSTFILE=/etc/hosts
PRINTERFILE=/etc/hosts.printers
ACTUALDATE=`date +%Y%m%d%H%M`

#Copy file before replace
cp -p $HOSTFILE $HOSTFILE.$ACTUALDATE
#Substract strings containing printer definition 
sed '/## INICIO Definicion de impresoras/,/## FIN Definicion de impresoras/d'i $HOSTFILE.$ACTUALDATEFILE > $HOSTFILE
#Introduce printer definition
cat $PRINTERFILE >> $HOSTFILE

if [ $(wc -l $PRINTERFILE) -lt 2) ]; then
	echo "Error en la generacion del fichero hosts"
	alertar()
	exit 1
fi

#Execute update sed
# ssh replace file sed

