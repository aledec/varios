#!/bin/ksh

## User specific settings
USERNAME=root
SERVERNAME=server
REMOTESCRIPT="/root/actualizar_hosts_contingencia_impresoras_sap.sh"

## File settings
#Destination directory
DSTDIRECTORY="/etc/"
#Printer File
PRINTERFILE=/etc/hosts.printers

#Execute copy . User must have access to destination path
rsync -v -e ssh $PRINTERFILE $USERNAME@$SERVERNAME:$DSTDIRECTORY
if [ $? -ne 0 ]; then
        echo "Error en la copia del fichero hosts"
        exit 1
fi

ssh -q $USERNAME@SERVERNAME $REMOTESCRIPT
if [ $? -ne 0 ]; then
        echo "Error en la ejecucion del update del fichero hosts"
        exit 1
fi
