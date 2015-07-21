#!/bin/ksh
######################################################
#                                                    #
# Script de chequeo de resultados de dbverify        #
# semanal - Reporte por correos con sendemail        #
# en caso de falla                                   #
#                                                    #
# Autor: aledec                                      #
# Creado: 20141113                                   #
#                                                    #
# Version: 1 - 20141113                              #
######################################################

#Configuracion
source dbverify_semanal.config.txt

existsapbackup() {
        if [ ! -d "$SAPBACKUP" ]; then
                #echo "NO EXISTE EL DIRECTORIO SABPACKUP" | mail ...
                MAILSUBJECT="DBVERIFY: No existe el directorio SAPBACKUP para el servidor $hostname - $SAPSID - $fecha"
                MAILMESSAGE="En la fecha $fecha se han presentado errores en la corrida."
                echo $MAILSUBJECT >> $0.log
                $SENDEMAIL -f "$FROMADRESS" -t "$MAILTO" -u "$MAILSUBJECT" -m "$MAILMESSAGE" -s $MAILSERVER >> $LOGFILE
                exit 10
        fi
}

existanydbv() {
        if [ ! -f $SAPBACKUP/$CHECKDBVERIFY ]; then
                MAILSUBJECT="DBVERIFY: No existe ningun archivo de dbverify para el servidor $hostname - $SAPSID - $fecha"
                MAILMESSAGE="En la fecha $fecha se han presentado errores en la corrida."
                echo $MAILSUBJECT >> $0.log
                $SENDEMAIL -f "$FROMADRESS" -t "$MAILTO" -u "$MAILSUBJECT" -m "$MAILMESSAGE" -s $MAILSERVER >> $LOGFILE
                exit 11
        fi
}

lastrundbverify() {
        YESTERDAY=`TZ=aaa24 date +%b%d`
        TODAY=`date +%b%d`
        cd $SAPBACKUP
        LASTRUN=$(ls -ltr $CHECKDBVERIFY | tail -1 | awk '{print $6$7}')
        cd - > /dev/null
        if [ $LASTRUN != $TODAY ]; then
            if [ $LASTRUN != $YESTERDAY ]; then
                MAILSUBJECT="DBVERIFY: La ultima corrida es mayor a 1 dia de antiguedad para el servidor $hostname - $SAPSID - $fecha"
                MAILMESSAGE="En la fecha $fecha se han presentado errores en la corrida."
                echo $MAILSUBJECT >> $0.log
                $SENDEMAIL -f "$FROMADRESS" -t "$MAILTO" -u "$MAILSUBJECT" -m "$MAILMESSAGE" -s $MAILSERVER >> $LOGFILE
                exit 12
            fi
        fi
}

erroresdbverify() {
        cd $SAPBACKUP
        LASTFILE=$(ls -1tr $CHECKDBVERIFY | tail -1)
        cd - > /dev/null
        CANTERRORES=$(grep "Corrupt block" $SAPBACKUP/$LASTFILE | wc -l)
        if [ $CANTERRORES -ge 1 ]; then
                MAILSUBJECT="DBVERIFY: Se han presentado ERRORES de datos para el servidor $hostname - $SAPSID - $fecha"
                MAILMESSAGE="En la fecha $fecha se han presentado errores en la corrida efectuada. Se adjuntan los ERRORES. Se requiere la revision de los mismos."
                echo $MAILSUBJECT >> $0.log
                $SENDEMAIL -f "$FROMADRESS" -t "$MAILTO" -u "$MAILSUBJECT" -m "$MAILMESSAGE" -s $MAILSERVER -a "$SAPBACKUP/$LASTFILE" >> $LOGFILE
                exit 0
        else
                MAILSUBJECT="DBVERIFY: No se han presentado ERRORES de datos para el servidor $hostname - $SAPSID - $fecha"
                echo $MAILSUBJECT >> $0.log
                exit 0
        fi
}

MAILMESSAGE=""
MAILSUBJECT=""
LASTRUN=""

##############################################
##############################################
### Inicio

#Salto de linea en el log
echo "######################" >> $LOGFILE
existsapbackup;
existanydbv;
lastrundbverify;
erroresdbverify;