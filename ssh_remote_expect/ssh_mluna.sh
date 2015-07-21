#!/bin/bash

#$1 -v (verbose)
verbose=$1
#$2 user
usuario=$2
#$3 sistema operativo
operating_system=$3
#$4 ubicacion
ubicacion=$4
#$5 A ejecutar/copiar origen
EXEC=$5
#$6 A copiar destino
EXEC2=$6

### Archivo a leer listado de servers
FILE=$0.txt

###########################################################################
#### FUNCIONES
###########################################################################

#### Mostrar ayuda
function ayuda ()
{
        echo "Uso: $0 [option] [operating_system] [location] [execution]"
        echo "     $0 -s unixadm all cotia 'echo "/home/mluna/cfg2html-linux-2.17/cfg2html-linux" | sudo su - root'"
        echo "     $0 -s root linux artigas /path/script.sh"
        echo "     $0 -S root linux artigas /home/origen/archivo_a_copiar.txt /home/destino/archivo_copiado.txt"
        echo "     $0 -Sr unixadm hpux cotia /etc /home/unixadm/backup_etc/ << El directorio debe existir"
        echo " "
        echo " # Parametros"
        echo "      [option]:"
        echo "        -s < SSH"
        echo "        -S < SCP"
        echo "        -Sr < SCP Reverso"
        echo "      [user]:"
        echo "        unixadm"
        echo "        root"
        echo "      [operating_system]:"
        echo "        linux"
        echo "        solaris"
        echo "        hpux"
        echo "        all"
        echo "      [location]:"
        echo "        artigas"
        echo "        cotia"
        echo "        all"
        echo "      [script]"
        echo "ERROR CODE: 38912"
        exit 2
}

function execexpectssh()
{
        SERVER=$1
        SERVERIP=$2
        SYSTEMOS=$3
        LOCATION=$4
        USER=$5
        USERPASSWORD=$6
	ROOTPASSWORD=$7
        # Si es root/otherdm
        if [ "$usuario" == "root" ];then
          if  [ "$EXEC" == "${halt/reboot/shutdown/init/}" ]; then
             echo "ERROR 876 - BRAIN NOT FOUND"
             ayuda
             exit 2
          else

#### Funcion en caso que se requiera ejecutar scp
function execscp ()
{
        SERVER=$1
        SERVERIP=$2
        SYSTEMOS=$3
        LOCATION=$4
        USER=$5
        USERPASSWORD=$6
        ROOTPASSWORD=$7
        # Si es root/otherdm
        if [ "$usuario" == "root" ];then
           echo ""
           echo " ROOT COPY!!!!! "
           echo "##################################################"
           echo "######## $SERVER - $SERVERIP - Sistema Operativo: $SYSTEMOS"
                echo "scp -r -q -o StrictHostKeyChecking=no -o ConnectTimeout=9 $EXEC root@$SERVERIP:$EXEC2"
           scp -r -o StrictHostKeyChecking=no -o ConnectTimeout=9 $EXEC root@$SERVERIP:$EXEC2
        else
           scp -r -o StrictHostKeyChecking=no -o ConnectTimeout=9 $EXEC $USER@$SERVERIP:$EXEC2
        fi

}

#### Funcion en caso que se requiera ejecutar scp
function execscp_reverso ()
{
        SERVER=$1
        SERVERIP=$2
        SYSTEMOS=$3
        LOCATION=$4
        USER=$5
        USERPASSWORD=$6
        ROOTPASSWORD=$7
        # Si es root/otherdm
        if [ "$usuario" == "root" ];then
           echo ""
           echo " ROOT COPY!!!!! "
           echo "##################################################"
           echo "######## $SERVER - $SERVERIP - Sistema Operativo: $SYSTEMOS"
	   echo "######## Creando Directorio para el servidor $SERVER ( $SERVERIP )"
	   mkdir $EXEC2/$SERVER
           scp -r -o StrictHostKeyChecking=no -o ConnectTimeout=9 root@$SERVERIP:$EXEC $EXEC2/$SERVER
        else
           scp -r -o StrictHostKeyChecking=no -o ConnectTimeout=9 $USER@$SERVERIP:$EXEC $EXEC2/$SERVER
        fi

}


#### Funcion en caso que se requiera ejecutar ssh
function execssh ()
{
        SERVER=$1
        SERVERIP=$2
        SYSTEMOS=$3
        LOCATION=$4
        USER=$5
        USERPASSWORD=$6
        ROOTPASSWORD=$7
        # Si es root/otherdm
        if [ "$usuario" == "root" ];then
          if  [ "$EXEC" == "${halt/reboot/shutdown/init/}" ]; then
           echo "ERROR 876 - BRAIN NOT FOUND"
           ayuda
           exit 2
          else
           echo ""
           echo " ROOT SHELL!!!!! "
           echo "##################################################"
           echo "######## $SERVER - $SERVERIP - Sistema Operativo: $SYSTEMOS"
           ssh -t -q -o StrictHostKeyChecking=no -o ConnectTimeout=9 root@$SERVERIP $EXEC
          fi
        else
         echo ""
         echo "##################################################"
         echo "######## $SERVER - $SERVERIP - Sistema Operativo: $SYSTEMOS"
         ssh -t -q -o StrictHostKeyChecking=no -o ConnectTimeout=9 $USER@$SERVERIP $EXEC
        fi
}

#### Funcion que compruebo la opcion solicitada y separo de acuerdo a lo requerido
function execfunc
{
        SERVER=$1
        SERVERIP=$2
        SYSTEMOS=$3
        LOCATION=$4
        USER=$5
        USERPASSWORD=$6
        ROOTPASSWORD=$7

        # Si es ssh
        if [ "$OPTION" -eq "0" ];then
                execssh $SERVER $SERVERIP $SYSTEMOS $LOCATION $USER $USERPASSWORD $ROOTPASSWORD
        # Si es scp
        elif [ "$OPTION" -eq "1" ];then
                execscp $SERVER $SERVERIP $SYSTEMOS $LOCATION $USER $USERPASSWORD $ROOTPASSWORD
        elif [ "$OPTION" -eq "2" ];then
                execscp_reverso $SERVER $SERVERIP $SYSTEMOS $LOCATION $USER $USERPASSWORD $ROOTPASSWORD
        fi
}

#### Funcion que compruebo la localidad del equipo y solo filtro los solicitados
function getplace ()
{
        SERVER=$1
        SERVERIP=$2
        SYSTEMOS=$3
        LOCATION=$4
        USER=$5
        USERPASSWORD=$6
        ROOTPASSWORD=$7

        if [[ $ubicacion =~ "all" ]];then
                execfunc $SERVER $SERVERIP $SYSTEMOS $LOCATION $USER $USERPASSWORD $ROOTPASSWORD
        elif [[ $ubicacion =~ $LOCATION ]];then
                execfunc $SERVER $SERVERIP $SYSTEMOS $LOCATION $USER $USERPASSWORD $ROOTPASSWORD
        fi
}

#### Funcion que compruebo el sistema operativo y solo filtro los solicitados
function getos ()
{
        SERVER=$1
        SERVERIP=$2
        SYSTEMOS=$3
        LOCATION=$4
        USER=$5
        USERPASSWORD=$6
        ROOTPASSWORD=$7

        if [[ $operating_system =~ "all" ]];then
                getplace $SERVER $SERVERIP $SYSTEMOS $LOCATION $USER $USERPASSWORD $ROOTPASSWORD
        elif [[ $operating_system =~ $SYSTEMOS ]];then
                getplace $SERVER $SERVERIP $SYSTEMOS $LOCATION $USER $USERPASSWORD $ROOTPASSWORD
        fi
}

###########################################################################
#### CONDICIONALES
###########################################################################

#### Condicional para falta de parametros
if [ $# -lt 5 ]; then
        echo "ERROR - Chequea los parametros ingresados"
        ayuda
fi

#### Condicional para verbose
#verbose=0
#if [ "$1" = "-v" ]; then
        #shift; verbose=1
#fi

#### Condicional para SCP / SSH
OPTION=0
if [ "$1" = "-s" ]; then
        shift; OPTION=0
elif [ "$1" = "-S" ]; then
        shift; OPTION=1
elif [ "$1" = "-Sr" ]; then
        shift; OPTION=2
else
        echo "ERROR - Chequea la opcion [-s/-S]"
        ayuda
fi

#### Lectura listado de ips y ejecucion
for line in $(cat $FILE)
do
        if [[ $line =~ "#" ]];then
                continue
        else
                getos $(echo $line | cut -d'|' -f1) $(echo $line | cut -d'|' -f2) $(echo $line | cut -d'|' -f3) $(echo $line | cut -d'|' -f4) $(echo $line | cut -d'|' -f5)
        fi
done
exit 0
