#!/usr/bin/ksh
ORG=$1
source conf/nbscript.conf
#source conf/senders.conf


##################################################################
## Reportes
##################################################################
function reporte_mail(){
read -p "Desea enviar por correo el fichero generado? " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
	DATE="$(date +%Y%m%d%H%M)"
	MAILSUBJECT="Reporte generado el dia $DATE"
	MAILMESSAGE="Se ha generado el siguiente reporte"
##agregar opcion seleccion correo(MAILTO con listado en senders.conf)
	        $SENDEMAIL -f "$FROMADRESS" -t "$MAILTO" -u "$MAILSUBJECT" -m "$MAILMESSAGE" -a $1 -s $MAILSERVER
fi
}

function reporte_pantalla(){
read -p "Desea mostrar por pantalla el fichero generado? " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
	more $1
fi
}

function listados(){
bpplclients -noheader -allunique | awk '{print $3}' > $NB_CLIENT
bppllist > $NB_POLICY
bpstulist -U | grep Label | awk '{print $2}' > $NB_STORAGE_UNITS
bpmedialist -l -mlist | awk '{print $1}' > $NB_MEDIA_LIST
}

##################################################################
# Seleccion
##################################################################
function loop_client_id(){
echo -e "\033[32m Ingrese el cliente id que corresponda: \033[0m"
read line
RESULTADOS=$(grep -i $line $NB_CLIENT | wc -l)
if [ $(grep -x $line $NB_CLIENT | wc -l) -eq 1 ]; then  #chequeo que coincida unicamente con la palabra ingresada, aunque haya multiples strings
        echo "Desea cambiar: $line (Y to change, any other key to continue)?"
        echo -e "-------------------------------------------"
        read -p ": "
                if [[ $REPLY =~ ^[Yy]$ ]]; then
                        loop_client_id
                else
                        CLIENT_ID=$(grep -x $line $NB_CLIENT)
                        echo "Se selecciono $CLIENT_ID"
                fi
elif [ $RESULTADOS -eq 1 ]; then #chequeo que coincida con al menos uno de las palabras ingresadas
        echo "Desea cambiar: $(grep -i $line $NB_CLIENT) (Y to change, any other key to continue)?"
        echo -e "-------------------------------------------"
        read -p ": "
                if [[ $REPLY =~ ^[Yy]$ ]]; then
                        loop_client_id
                else
                        CLIENT_ID=$(grep -i $line $NB_CLIENT)
                        echo "Se selecciono $CLIENT_ID"
                fi
elif [ $RESULTADOS -eq 0 ]; then #sin resultados
        echo "No se encontraron resultados"
        echo -e "-------------------------------------------"
        loop_client_id
else #multiples resultados, voy a loop
        echo -e "Se han encontrado los siguientes resultados"
        echo -e "-------------------------------------------"
        grep -i $line $NB_CLIENT
        loop_client_id

fi
}

function loop_policy_id(){
echo -e "\033[32m Ingrese la policy id que corresponda: \033[0m"
read line
RESULTADOS=$(grep -i $line $NB_POLICY | wc -l)
if [ $(grep -x $line $NB_POLICY | wc -l) -eq 1 ]; then  #chequeo que coincida unicamente con la palabra ingresada, aunque haya multiples strings
        echo "Desea cambiar: $line (Y to change, any other key to continue)?"
        echo -e "-------------------------------------------"
        read -p ": "
                if [[ $REPLY =~ ^[Yy]$ ]]; then
                        loop_client_id
                else
                        POLICY_ID=$(grep -x $line $NB_POLICY)
                        echo "Se selecciono $POLICY_ID"
                fi
elif [ $RESULTADOS -eq 1 ]; then #chequeo que coincida con al menos uno de las palabras ingresadas
        echo "Desea cambiar: $(grep -i $line $NB_POLICY) (Y to change, any other key to continue)?"
        echo -e "-------------------------------------------"
        read -p ": "
                if [[ $REPLY =~ ^[Yy]$ ]]; then
                        loop_policy_id
                else
                        POLICY_ID=$(grep -i $line $NB_POLICY)
                        echo "Se selecciono $POLICY_ID"
                fi
elif [ $RESULTADOS -eq 0 ]; then #sin resultados
        echo "No se encontraron resultados"
        echo -e "-------------------------------------------"
        loop_client_id
else #multiples resultados, voy a loop
        echo -e "Se han encontrado los siguientes resultados"
        echo -e "-------------------------------------------"
        grep -i $line $NB_POLICY
        loop_policy_id
fi
}


##################################################################
## Opciones
##################################################################
function option_1(){
bpplclients -noheader -allunique | awk '{print $3}' > $NB_CLIENT
reporte_pantalla $NB_CLIENT
reporte_mail $NB_CLIENT
}
function option_2(){
bpplclients -allunique > $NB_CLIENT_DETAIL
reporte_pantalla $NB_CLIENT_DETAIL
reporte_mail $NB_CLIENT_DETAIL
}
function option_3(){
bppllist > $NB_POLICY
reporte_pantalla $NB_POLICY
reporte_mail $NB_POLICY
}
function option_4(){
bppllist -U -allclasses> $NB_POLICY_DETAIL
reporte_mail $NB_POLICY_DETAIL
}
function option_5(){
loop_client_id
bppllist -U -allclasses -policy $CLIENT_ID > $TMPDIR/nb_policy_detail_$CLIENT_ID.txt
reporte_pantalla $TMPDIR/nb_policy_detail_$CLIENT_ID.txt
reporte_mail $TMPDIR/nb_policy_detail_$CLIENT_ID.txt
}
function option_30(){
loop_client_id
bpimagelist -U -client $CLIEND_ID -hoursago 168 > $TMPDIR/nb_image_detail_$CLIENT_ID.$DATE.txt
reporte_pantalla $TMPDIR/nb_image_detail_$CLIENT_ID.$DATE.txt
reporte_mail $TMPDIR/nb_image_detail_$CLIENT_ID.$DATE.txt
}
function option_31(){
loop_client_id
bpimagelist -U -client $CLIEND_ID -hoursago 720 > $TMPDIR/nb_image_detail_$CLIENT_ID.$DATE.txt
reporte_pantalla $TMPDIR/nb_image_detail_$CLIENT_ID.$DATE.txt
reporte_mail $TMPDIR/nb_image_detail_$CLIENT_ID.$DATE.txt
}
function option_32(){
bperror -U -backstat -s info -hoursago 24 > $TMPDOR/nb_backup_error_$DATE.txt
reporte_pantalla $TMPDOR/nb_backup_error_$DATE.txt
reporte_mail $TMPDOR/nb_backup_error_$DATE.txt
}
function option_33(){
bperror -U -backstat -s info -hoursago 168 > $TMPDOR/nb_backup_error_$DATE.txt
reporte_pantalla $TMPDOR/nb_backup_error_$DATE.txt
reporte_mail $TMPDOR/nb_backup_error_$DATE.txt
}
function option_34(){
bperror -U -backstat -s error -hoursago 24 > $TMPDOR/nb_backup_error_$DATE.txt
reporte_pantalla $TMPDOR/nb_backup_error_$DATE.txt
reporte_mail $TMPDOR/nb_backup_error_$DATE.txt
}
function option_35(){
bperror -U -backstat -s error -hoursago 168 > $TMPDIR/nb_backup_error_$DATE.txt
reporte_pantalla $TMPDIR/nb_backup_error_$DATE.txt
reporte_mail $TMPDIR/nb_backup_error_$DATE.txt
}
function option_36(){
bperror -U -problems -hoursago 24 > $TMPDIR/nb_backup_problem_$DATE.txt
reporte_pantalla $TMPDIR
reporte_mail $TMPDIR
}
function option_37(){
bperror -U -problems -hoursago 168 > $TMPDIR/nb_backup_problem_$DATE.txt
reporte_pantalla $TMPDIR
reporte_mail $TMPDIR
}
function option_38(){
loop_client_id
bperror -U -problems -hoursago 168 > $TMPDIR/nb_backup_problem_$DATE.txt
reporte_pantalla $TMPDIR
reporte_mail $TMPDIR
}
function option_39(){
loop_client_id
bperror -U -problems -hoursago 168 > $TMPDIR/nb_backup_problem_$DATE.txt
reporte_pantalla $TMPDIR
reporte_mail $TMPDIR
}
function option_40(){
loop_policy_id
bpimagelist -U -policy $POLICY_ID > $TMPDIR/nb_policy_$POLICY_ID_$DATE.txt
reporte_pantalla $TMPDIR
reporte_mail $TMPDIR
}

OUTPUT=output.txt

if [ $# != 1 ]
then
echo -e "\033[45m Herramientas de Netbackup\033[0m"

echo -e "\n******************\033[44m Listados configuraciones Clientes/Politicas\033[0m ******************"
echo -e "\033[1m 1.  \033[33;31m Listado Clientes Backup \033[0m"
echo -e "\033[1m 2.  \033[33;31m Listado Clientes Backup Detallado \033[0m"
echo -e "\033[1m 3.  \033[33;32m Listado Politicas Backup \033[0m"
echo -e "\033[1m 4.  \033[33;32m Listado Politicas Backup Detallado \033[0m"
echo -e "\033[1m 5.  \033[33;32m Listado Politicas Backup de cliente especifico\033[0m"


echo -e "\n******************\033[44m JOBS \033[0m ******************"

echo -e "\n******************\033[44m REPORTES \033[0m ******************"
echo -e "\033[1m 30.  \033[33;31m Listado ultimos 7 dias backup del cliente <clientname> \033[0m"
echo -e "\033[1m 31.  \033[33;31m Listado ultimos 30 dias backup del cliente <clientname> \033[0m"
echo -e "\033[1m 32.  \033[33;32m Reporte resultados backups ultimas 24horas \033[0m" 
echo -e "\033[1m 33.  \033[33;32m Reporte resultados backups ultimos 7 dias \033[0m" 
echo -e "\033[1m 34.  \033[33;33m Reporte resultados backups fallidos en las ultimas 24horas\033[0m" 
echo -e "\033[1m 35.  \033[33;33m Reporte resultados backups fallidos en las ultimos 7 dias\033[0m" 
echo -e "\033[1m 36.  \033[33;34m Errores presentados en los backups de las ultimas 24horas \033[0m"
echo -e "\033[1m 37.  \033[33;34m Errores presentados en los backups de los ultimos 7 dias \033[0m"
echo -e "\033[1m 38.  \033[33;31m Errores presentados en los backups del <clientename> de los ultimos 7 dias \033[0m"
echo -e "\033[1m 39.  \033[33;31m Errores presentados en los backups del <clientename> de los ultimos 30 dias \033[0m"
echo -e "\033[1m 40.  \033[33;32m Listado de imagenes de backup por policy \033[0m"

echo -e "\n******************\033[44m MEDIA \033[0m ******************"
echo -e "\033[1m 50.  \033[33;31m Listado completo de MEDIA disponibles en el servidor \033[0m"
echo -e "\033[1m 51.  \033[33;32m Listado detallado del contenido de una media [Requiere montarla en robot] \033[0m"
echo -e "\033[1m 52.  \033[33;33m Listado detallado del contenido de una media - IMAGENES [Requiere montarla en robot] \033[0m"

echo -e "\n******************\033[44m Recovery options \033[0m ******************"
echo -e "\033[1m 100.  \033[33;31m Chequear conectividad con cliente <ip> / hostname \033[0m"
echo -e "\033[1m 101.  \033[33;32m Detener Netbackup \033[0m"
echo -e "\033[1m 102.  \033[33;33m Iniciar Netbackup \033[0m"
echo -e "\033[1m 102.  \033[33;34m Mostrar procesos netbackup \033[0m"
echo -e "\033[1m 103.  \033[33;31m Volver a cargar configuracion Netbackup sin reiniciar \033[0m"





## Seleccion
echo -e
echo -e "\033[42m Ingrese el valor \033[0m"
read ch
  a=$ch
  else
  a=$ORG
fi
case $a in
0)echo "opcion de prueba. No existe esta opcion, seleccione otra";;
1)option_1;;
2)option_2;;
3)option_3;;
4)option_4;;
5)option_5;;
30)option_30;;
31)option_31;;
32)option_32;;
33)option_33;;
34)option_34;;
35)option_35;;
36)option_36;;
37)option_37;;
38)option_38;;
39)option_39;;
40)option_40;;
50)echo "no habilitado";;#bpmedialist -U -mlist;;
51)echo "no habilitado";;#bpmedialist -U -mcontents -m media_id;;
52)echo "no habilitado";;#bpimmedia -U -client client_name -mediaid media_id;;
100)echo "no habilitado";;#bpclntcmd -ip ip
101)echo "no habilitado";;#netbackup stop;bprdreq -terminate;bpdbm -terminate;/goodies/bp.kill_all
102)echo "no habilitado";;#netbackup start;initbprd;vmd
103)echo "no habilitado";;#bprdreq -rereadconfig

*)echo -e "Entrada Invalida!!!" ;;
esac

## LOOP
echo -e "\033[32m "
read -p "Desea ejecutar otra opcion [Yy] [Nn]? " -n 1 -r
echo -e "\033[0m"
if [[ $REPLY =~ ^[Yy]$ ]]; then
	ORG=""
	menu
else
	echo "Saliendo."
	exit
fi
}

#########################################################333
## INICIO PROGRAMA
menu

