#!/bin/bash

LISTA_EQUIPOS=$0.txt
echo "########## IMPORTANTE ###########"
echo ""
echo "Recuerde que este script se autentifica con el usuario nominal y causara problemas si la passwd ingresada es incorrecta(Bloqueo de Usuario). Uselo Con precaucion"
echo "Si desea cancelar presione Ctrl + C"
echo ""
echo "#################################"
echo "Introduzca contrasena"
read -sp'Password: ' passwd
echo ""

echo "Servidor Dia_Inicio Horario_Inicio Dia_Finalizacion Horario_Finalizacion Duracion Codigo_Retorno" > $0.servidorestatus
while read line; do
 echo "# Servidor: $line"
 #retorno=$(./expect_ssh.sh $passwd $line | sed '/spawn/,/texttoremove/d' | grep -v texttoremove | grep STAT | awk -F"|" '{print $2 " " $3 " " $4 " " $5 " " $6 " " $19 " " $20}')
 ./expect_ssh.sh $passwd $line | sed '/spawn/,/texttoremove/d' | grep -v texttoremove | grep STAT | awk -F"|" '{print $2 " " $3 " " $4 " " $5 " " $6 " " $19 " " $20}' >> $0.servidorestatus

 #echo "$line $(echo $retorno | awk '{print $2}') $(echo $retorno | awk '{print $3}') $(echo $retorno | awk '{print $4}') $(echo $retorno | awk '{print $5}') $(echo $retorno | awk '{print $6}') $(echo $retorno | awk '{print $7}')">> $0.servidorestatus
 echo "###############################################"
 #echo $?
#sleep 1
done < <(cat $LISTA_EQUIPOS|grep -v "#")
