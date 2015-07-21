#!/bin/bash -x

###########################################################################
#### FUNCIONES
###########################################################################

function recorrer ()
{
for line in $(cat $CONFIGURATION.include)
do
        if [[ $line =~ "#" ]];then
                continue
        else
                rsyncf $(echo $line | cut -d'|' -f1) $(echo $line | cut -d'|' -f2)
        fi
done
}

function rsyncf ()
{       
        #Server and user variables are been imported from configuration file
	FILEPATH=$1
	DSTFILEPATH=$2
	 $RSYNCBIN $OPTION $RSYNCOPTIONS $FILEPATH $USERNAME@$REMOTESERVERNAME:$DSTFILEPATH
#echo $FILEPATH
#echo $DSTFILEPATH
}

#### Mostrar ayuda
function ayuda ()
{
        echo "Uso: $0 [configurationfile] [option]"
        echo "     $0 conf/server01.conf -v"
        echo " "
        echo " # Parametros"
        echo "      [configurationfile]: Server Name configuration file"
        echo "      [option]:"
        echo "        -v: Verbose"
        exit 2
}


###########################################################################
#### INICIO
###########################################################################
if [ $# -lt 1 ]; then
        echo -en '\E[47;31m'"\033[1m ERROR - Chequea los parametros ingresados \033[0m\n"
        ayuda
else
        CONFIGURATION=$1
	#OPTION=$2
	if [ -e $CONFIGURATION ]; then
        	source $CONFIGURATION
		recorrer
	fi
	#if [ -z $OPTION] && [ $OPTION != '-v' ]; then
		#echo -en '\E[47;31m'"\033[1m ERROR - Ingreso de opcion incorrecta \033[0m\n"
		#ayuda
	#fi
fi
