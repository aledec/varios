#!/bin/bash 

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
                scpf $(echo $line | cut -d'|' -f1) $(echo $line | cut -d'|' -f2)
        fi
done
}

function scpf ()
{
	FILEPATH=$1
	DSTFILEPATH=$2
	scp $OPTION $SCPOPTIONS $FILEPATH $USERNAME@$REMOTESERVERNAME:$DSTFILEPATH
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
fi
