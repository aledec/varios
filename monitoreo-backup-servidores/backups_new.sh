#!/bin/bash

###################################################################
# Script que limpia el reporte diario de backups en ambientes SAP #
# y convierte a un formato legible para un ser humano normal.     #
#                                                                 #
# AUTOR             FECHA            COMENTARIOS                  #
# Mariano Luna      26-02-2014       version inicial              #
###################################################################

########################################
## FUNCIONES
########################################

## Solicito la fecha para poder realizar la comparacion
echo "Introduzca la fecha del ultimo viernes en formato 2014-12-31"
read -p'Fecha: ' date
#Convierto la fecha a un formato legible
conddate=$(date -d $date +"%y%m%d")


inicio()
{
	rm -f $0.tmp
	rm -f $0.tmp.sinbackupsemanal
	rm -f $0.tmp.conbackupsemanal
	rm -f $0.tmp.sinbajadadebasededatos
	rm -f $0.tmp.baseerror
}
## Funcion limpieza - borra los temporales
limpieza()
{
	rm -f $0.tmp
        rm -f $0.tmp.hostname
        rm -f $0.tmp.basebajo
        rm -f $0.tmp.basesubio
        rm -f $0.tmp.backupsemcomenzo
	rm -f $0.tmp.backupsemtermino
	rm -f $0.tmp.baseerror
}

## Listadoservidores - calcula el listado de servidores de acuerdo al fichero backups.txt
listadoservidores()
{
	cat backups.txt | grep sua| grep -v "#"| grep -e "---"| awk '{print $2}' > listado_servidores_backups.txt
}


## chequeostatusssh - realiza una conexion ssh con cada servidor para verificar si retorno correctamente el backup(verifica el ultimo digito del ultimo fichero semanal)
chequeostatusssh()
{
	#invoco al script externo de conexion para chequeo de status ssh
	echo "test"
}


## Calculofechas - calculo las fechas enviadas
calculofechasbackup()
{
	todatebackup=$(date -d $(cat $0.tmp.backupsemtermino | awk '{print $1}') +"%y%m%d")
	if [ -f $0.tmp.basesubio ] && [ ! -f $0.tmp.baseerror ]; then
		todatebase=$(date -d $(cat $0.tmp.basesubio | awk '{print $1}') +"%y%m%d")
	fi
	# Verifico si existe el fichero para evitar errores en servidores sin base
	## Chequeo si la fecha solicitada es mayor a la fecha del reporte de backup, si es asi informo
	if [ $conddate -ge $todatebackup ]; then
		echo "##################################################################" >> $0.tmp.sinbackupsemanal
		echo "Hostname: $(cat $0.tmp.hostname)" >> $0.tmp.sinbackupsemanal
		echo "El ultimo backup semanal comenzo: $(cat $0.tmp.backupsemcomenzo)" >> $0.tmp.sinbackupsemanal
		echo "El ultimo backup semanal finalizo: $(cat $0.tmp.backupsemtermino)" >> $0.tmp.sinbackupsemanal
		if [ $(cat $0.tmp.basebajo | grep "NO EXISTE BASE ARRIBA" | wc -l) -eq 1 ]; then
			echo "El entorno no tiene base de datos" >> $0.tmp.sinbackupsemanal
		elif [ -f $0.tmp.baseerror ]; then
			echo "# El chequeo de base de datos presenta ERRORES" >> $0.tmp.sinbackupsemanal
		elif [ $(cat $0.tmp.basebajo | grep -v "NO EXISTE BASE ARRIBA" | wc -l) -eq 1 ]; then
			echo "La ultima bajada de la base de datos fue: $(cat $0.tmp.basebajo)" >> $0.tmp.sinbackupsemanal
			echo "La ultima subida de la base de datos fue: $(cat $0.tmp.basesubio)" >> $0.tmp.sinbackupsemanal
		fi
		echo "" >> $0.tmp.sinbackupsemanal
	## Agrego un condicional por si se reporta un error de due to -... a nivel de alert de oracle, para que se corrija
	elif [ -f $0.tmp.baseerror ]; then
                echo "##################################################################" >> $0.tmp.sinbajadadebasededatos
                echo "Hostname: $(cat $0.tmp.hostname)" >> $0.tmp.sinbajadadebasededatos
                echo "El ultimo backup semanal comenzo: $(cat $0.tmp.backupsemcomenzo)" >> $0.tmp.sinbajadadebasededatos
                echo "El ultimo backup semanal finalizo: $(cat $0.tmp.backupsemtermino)" >> $0.tmp.sinbajadadebasededatos
		echo "# El chequeo de base de datos presenta ERRORES" >> $0.tmp.sinbajadadebasededatos
                echo "La ultima bajada de la base de datos fue: $(cat $0.tmp.basebajo)" >> $0.tmp.sinbajadadebasededatos
                echo "La ultima subida de la base de datos fue: $(cat $0.tmp.basesubio)" >> $0.tmp.sinbajadadebasededatos
	## Chequeo si la fecha solicitada es mayor a la fecha de la ultima bajada de base, si lo es informo
	elif [ -f $0.tmp.basesubio ] && [ $conddate -ge $todatebase ]; then
                echo "##################################################################" >> $0.tmp.sinbajadadebasededatos
                echo "Hostname: $(cat $0.tmp.hostname)" >> $0.tmp.sinbajadadebasededatos
                echo "El ultimo backup semanal comenzo: $(cat $0.tmp.backupsemcomenzo)" >> $0.tmp.sinbajadadebasededatos
                echo "El ultimo backup semanal finalizo: $(cat $0.tmp.backupsemtermino)" >> $0.tmp.sinbajadadebasededatos
		echo "La ultima bajada de la base de datos fue: $(cat $0.tmp.basebajo)" >> $0.tmp.sinbajadadebasededatos
		echo "La ultima subida de la base de datos fue: $(cat $0.tmp.basesubio)" >> $0.tmp.sinbajadadebasededatos
		echo "" >> $0.tmp.sinbajadadebasededatos
	## Chequeo si la fecha introducida es menor a la fecha de backup, si lo es todo salio OK
	elif [ $todatebackup -ge $conddate ]; then
                echo "##################################################################" >> $0.tmp.conbackupsemanal
                echo "Hostname: $(cat $0.tmp.hostname)" >> $0.tmp.conbackupsemanal
                echo "El ultimo backup semanal comenzo: $(cat $0.tmp.backupsemcomenzo)" >> $0.tmp.conbackupsemanal
                echo "El ultimo backup semanal finalizo: $(cat $0.tmp.backupsemtermino)" >> $0.tmp.conbackupsemanal
		echo "La ultima bajada de la base de datos fue: $(cat $0.tmp.basebajo)" >> $0.tmp.conbackupsemanal
                echo "La ultima subida de la base de datos fue: $(cat $0.tmp.basesubio)" >> $0.tmp.conbackupsemanal
		echo "" >> $0.tmp.conbackupsemanal
	else
		echo "################ ERROR con el hostname: $(cat $0.tmp.hostname)"
	fi
rm -f $0.tmp.lock
}
#######################################
## INICIO DEL PROGRAMA
#######################################

#Chequeo corrida
if [ ! -f $0.tmp ]; then
        inicio
        ## Limpio el archivo de fechas incorrectas, saltos de linea e informacion innecesaria
        cat backups.txt | grep -v "#" | grep -v "La lista" | sed '/^$/d' | sed -e 's/^[ \t]*//' | sed 's/Jan/01/'|sed 's/Feb/02/' | sed 's/Mar/03/' | sed 's/Apr/04/' | sed 's/May/05/' | sed 's/Jun/06/' | sed 's/Jul/07/' | sed 's/Aug/08/' | sed 's/Sep/09/' | sed 's/Oct/10/' | sed 's/Nov/11/' | sed 's/Dec/12/' > $0.tmp
fi
	

## Recorro el archivo limpio linea por linea
while read line; do
	## Si termino con un loop
	if [ -f $0.tmp.lock ]; then
                ## Invoco calculo de fechas del anterior loop
                calculofechasbackup
	elif [ $(echo $line | grep -e '-----------------------------------' | wc -l) -eq 1 ]; then
		## Limpio las variables que declaran el hostname y guardo el hostname del servidor
		limpieza
		hostname=$(echo $line | sed 's/----------------------------------->//' | sed 's/-------------------------------------//' | sed -e 's/^[\t]*//')
		 echo $hostname > $0.tmp.hostname
		 #echo "Chequeando el servidor $hostname"
	## Chequeo si la linea corresponde a un entorno dentro de ese servidor
	elif [ $(echo $line | grep sua | wc -l) -eq 1 ]; then
		## Limpio las variables que declaran el hostname y guardo el hostname del servidor + entorno
		limpieza
		hostname=$(echo $line | sed 's/----------------------------------->//' | sed 's/-------------------------------------//' | sed -e 's/^[\t]*//')
		 echo $hostname > $0.tmp.hostname
		 #echo "Chequeando el servidor + entorno $hostname"
	## Chequeo si corresponde a la linea de la base bajo
	elif [ $(echo $line | grep "La base Bajo" | wc -l) -eq 1 ]; then
		## Chequeo si la linea me informa si hay base o no
		if [ $(echo $line | grep -v "NO EXISTE BASE ARRIBA" | wc -l) -eq 1 ]; then
			basebajo=$(echo $line | sed 's/La base Bajo//' | sed 's/-->//')
			 echo $basebajo > $0.tmp.basebajo
			 #echo "La base bajo $basebajo"
		fi
	## Chequeo si corresponde a la linea de backup semanal comenzo
	elif [ $(echo $line | grep "Backup Sem Comenzo" | wc -l) -eq 1 ]; then
		backupsemcomenzo=$(echo $line | sed 's/Backup Sem Comenzo--> //')
		 echo $backupsemcomenzo > $0.tmp.backupsemcomenzo
		 #echo "El backup semanal comenzo $backupsemcomenzo"
	## Chequeo si corresponde a la linea de finalizacion de backup semanal
 	elif [ $(echo $line | grep "Backup Sem Termino" | wc -l) -eq 1 ]; then
		backupsemtermino=$(echo $line | sed 's/Backup Sem Termino--> //'| awk '{print $1 " " $2}')
		 echo $backupsemtermino > $0.tmp.backupsemtermino
		 #echo "El backup semanal termino $backupsemtermino"
		 ## Creo un lock file para poder invocar en la proxima linea el calculo solo si no hay base de datos, sino paso al siguiente elif
		 if [ -f $0.tmp.basesubio ]; then
			 touch $0.lock
		 fi
	## Chequeo si corresponde a la linea de finalizacion de backup base de datos. solo existe si hay base
        elif [ $(echo $line | grep "La base Subio" | wc -l) -eq 1 ]; then
		#Condicional por si en el alert se reporta un error de oracle(prerequisitos no cumplidos)
		if [ $(echo $line | grep due | wc -l) -eq 1 ];then
			touch $0.tmp.baserror
		fi
		basesubio=$(echo $line | awk '{print $5 " " $6}')
		echo $basesubio > $0.tmp.basesubio
		## Creo un lock file para poder invocar en la proxima linea el calculo
		touch $0.tmp.lock
	else
		echo "ERROR en loop de linea"
	fi
done < $0.tmp

# Invoco al finalizar para la ultima linea
##
#inicio
calculofechasbackup
listadoservidores
#coneccionssh
limpieza
