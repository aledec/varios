#!/bin/bash

#Importo el listado de servidores y caracteristicas
LISTA_EQUIPOS=$0.txt
#Saco la hora de ejecucion
EXDATE=$(date +%Y%m%d%H%M%S)
echo "########## IMPORTANTE ###########"
echo ""
echo "Recuerde que este script se autentifica con el usuario nominal y causara problemas si la passwd ingresada es incorrecta(Bloqueo de Usuario). Uselo Con precaucion"
echo "Si desea cancelar presione Ctrl + C"
echo ""
echo "#################################"
echo "Introduzca contrasena"
read -sp'Password: ' passwd
echo ""
echo "Introduzca el path del archivo/directorio a copiar"
read 'pathorigen'
echo ""
echo "#################################"
echo ""
echo "Los ficheros seran copiados al directorio $EXDATE/servername"
echo ""
echo "#################################"
#remuevo fichero anterior para evitar retorno incorrecto
rm -f $0.servidoresstatus
#Creo el directorio de ejecucion para copiar los rachivos
mkdir $EXDATE

while read line; do
 echo "# Servidor: $line"
 servername=$(echo $line|awk '{print $1}')
 mkdir -p $EXDATE/$servername
 retorno=$(./expect_scp.sh $passwd $pathorigen $EXDATE/$servername $servername)
 #retorno=$(./expect_ssh.sh $passwd $line | sed '/spawn/,/texttoremove/d' | grep -v texttoremove | grep STAT | awk -F"|" '{print $20}')
 #echo "Status backup: $retorno"
  #echo "Servidor: " $line " Status: " $retorno >> $0.servidoresstatus
 echo "###############################################"
 #echo $?
sleep 1
done < <(cat $LISTA_EQUIPOS|grep -v "#")

