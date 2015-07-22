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
        if [ "$USER" == "root" ];then
           echo ""
           echo -e "\033[1m ## ROOT COPY  ##\033[0m"
           echo -e "\E[31;1mREMEMBER - ROOT Login may not be available in all SYSTEMS"; tput sgr0
           echo -e "\E[34;1mUSING PASSWORD PUBKEY OPTION - MAX OUTPUT 100000 lines"; tput sgr0
           echo -e "\033[1m######## $SERVER - $SERVERIP - Sistema Operativo: $SYSTEMOS\033[0m\n"
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
        if [ "$USER" == "root" ];then
           echo ""
           echo -e "\033[1m ## ROOT COPY REVERSE ##\033[0m"
           echo -e "\E[31;1mREMEMBER - ROOT Login may not be available in all SYSTEMS"; tput sgr0
           echo -e "\E[34;1mUSING PASSWORD PUBKEY OPTION - MAX OUTPUT 100000 lines"; tput sgr0
           echo -e "\033[1m######## $SERVER - $SERVERIP - Sistema Operativo: $SYSTEMOS\033[0m"
           echo -e "\033[1m######## Creando Directorio para el servidor $SERVER ( $SERVERIP )\033[0m\n"
           mkdir $EXEC2/$SERVER
           scp -r -o StrictHostKeyChecking=no -o ConnectTimeout=9 root@$SERVERIP:$EXEC $EXEC2/$SERVER
        else
           scp -r -o StrictHostKeyChecking=no -o ConnectTimeout=9 $USER@$SERVERIP:$EXEC $EXEC2/$SERVER
        fi

}

#### Funcion en caso que se requiera ejecutar ssh con expectAH
function execsshexpectpasswd ()
{
        SERVER=$1
        SERVERIP=$2
        SYSTEMOS=$3
        LOCATION=$4
        USER=$5
        USERPASSWORD=$6
        ROOTPASSWORD=$7
        # Si es root/otherdm
        if [ "$USER" == "root" ];then
          if  [ "$EXEC" == "${halt/reboot/shutdown/init/}" ]; then
           echo -en '\E[47;31m'"\033[1m ERROR 876 - BRAIN NOT FOUND \033[0m\n"
           ayuda
           exit 2
          else 
           echo ""
           echo -en '\E[5m'
           echo -e "\E[31;1m## ROOT SHELL ##"; tput sgr0
           echo -e "\E[31;1mREMEMBER - ROOT Login may not be available in all SYSTEMS"; tput sgr0
           echo -e "\E[34;1mUSING PASSWORD PRE ENTER OPTION - MAX OUTPUT 100000 lines"; tput sgr0
           echo -e "\033[1m##################################################\033[0m"
           echo -e "\033[1m######## $SERVER - $SERVERIP - Sistema Operativo: $SYSTEMOS\033[0m\n"
           EXPVAR=$(expect -c "
            spawn ssh -t -q -o StrictHostKeyChecking=no -o ConnectTimeout=9  root@$SERVERIP $EXEC
            match_max 100000
            expect \"*?assword:*\"
            send -- \"$ROOTPASSWORD\r\"
	    send -- \"\r\"
            expect EOF
            ")
            echo "$EXPVAR" | grep -v "$USER@$SERVERIP"
          fi
        else
         echo ""
         echo -e "\E[34;1mUSING PASSWORD PRE ENTER OPTION - MAX OUTPUT 100000 lines"; tput sgr0
           echo -e "\033[1m##################################################\033[0m"
           echo -e "\033[1m######## $SERVER - $SERVERIP - Sistema Operativo: $SYSTEMOS\033[0m\n"
           echo $EXEC
           EXPVAR=$(expect -c "
            spawn ssh -t -q -o StrictHostKeyChecking=no -o ConnectTimeout=9  $USER@$SERVERIP
            match_max 100000
            expect \"*?assword:*\"
            send -- \"$USERPASSWORD\r\" 
	    send -- \"\r\"
            ")
            #echo "$EXPVAR" | grep -v "$USER@$SERVERIP"
        fi
}

#### Funcion en caso que se requiera ejecutar ssh con expectAH
function execsshexpect ()
{
        SERVER=$1
        SERVERIP=$2
        SYSTEMOS=$3
        LOCATION=$4
        USER=$5
        USERPASSWORD=$6
        ROOTPASSWORD=$7
        # Si es root/otherdm
        if [ "$USER" == "root" ];then
          if  [ "$EXEC" == "${halt/reboot/shutdown/init/}" ]; then
           echo -en '\E[47;31m'"\033[1m ERROR 876 - BRAIN NOT FOUND \033[0m\n"
           ayuda
           exit 2
          else 
           echo ""
           echo -en '\E[5m'
           echo -e "\E[31;1m## ROOT SHELL ##"; tput sgr0
           echo -e "\E[31;1mREMEMBER - ROOT Login may not be available in all SYSTEMS"; tput sgr0
           echo -e "\E[34;1mUSING PASSWORD PRE ENTER OPTION - MAX OUTPUT 100000 lines"; tput sgr0
           echo -e "\033[1m##################################################\033[0m"
           echo -e "\033[1m######## $SERVER - $SERVERIP - Sistema Operativo: $SYSTEMOS\033[0m\n"
           EXPVAR=$(expect -c "
            spawn ssh -t -q -o StrictHostKeyChecking=no -o ConnectTimeout=9  root@$SERVERIP $EXEC
            match_max 100000dria uqe esta
            expect \"*?assword:*\"
            send -- \"$ROOTPASSWORD\r\"
	    send -- \"\r\"
            expect EOF
            ")
            echo "$EXPVAR" | grep -v "$USER@$SERVERIP"
          fi
        else
         echo ""
         echo -e "\E[34;1mUSING PASSWORD PRE ENTER OPTION - MAX OUTPUT 100000 lines"; tput sgr0
           echo -e "\033[1m##################################################\033[0m"
           echo -e "\033[1m######## $SERVER - $SERVERIP - Sistema Operativo: $SYSTEMOS\033[0m\n"
           EXPVAR=$(expect -c "
            spawn ssh -t -q -o StrictHostKeyChecking=no -o ConnectTimeout=9  $USER@$SERVERIP $EXEC
            match_max 100000
            expect \"*?assword:*\"
            send -- \"$USERPASSWORD\r\"
	    send -- \"\r\"
            expect EOF
            ")
            echo "$EXPVAR" | grep -v "$USER@$SERVERIP"
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
        if [ "$USER" == "root" ];then
          if  [ "$EXEC" == "${halt/reboot/shutdown/init/}" ]; then
           echo -en '\E[47;31m'"\033[1m ERROR 876 - BRAIN NOT FOUND \033[0m\n"
		echo -en '\E[47;31m'"\033[1m You didnt say the magic world. $EXEC not allow  \033[0m\n"
           ayuda
           exit 2
          else
           echo ""
           echo -e "\E[31;1m## ROOT SHELL ##"; tput sgr0
           echo -e "\E[31;1mREMEMBER - ROOT Login may not be available in all SYSTEMS"; tput sgr0
           echo -e "\E[34;1mUSING PASSWORD PUBKEY OPTION - MAX OUTPUT 100000 lines"; tput sgr0
           echo -e "\033[1m##################################################\033[0m"
           echo -e "\0n33[1m######## $SERVER - $SERVERIP - Sistema Operativo: $SYSTEMOS\033[0m\n"
           ssh -t -q -o StrictHostKeyChecking=no -o ConnectTimeout=9 root@$SERVERIP $EXEC
          fi
        else
      	   echo ""
           echo -e "\033[1m##################################################\033[0m\n"
           echo -e "\033[1m######## $SERVER - $SERVERIP - Sistema Operativo: $SYSTEMOS\033[0m\n"
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

        # modifico la variable $USER usada para conectarse a los servers dependiendo si el usuario selecciono el usuario en el listado(opcion none) u otro manualmente
        if [ "$usuario" != "none" ];then
	   USER=$usuario
	#else  USUARIO=$USUARIO # Agregada a modo ejemplo, no se requiere por que se asigna
	fi
        # Condicionales de opcion elegida
        
        if [ "$OPTION" -eq "0" ];then #SSH
                execssh $SERVER $SERVERIP $SYSTEMOS $LOCATION $USER $USERPASSWORD $ROOTPASSWORD
        elif [ "$OPTION" -eq "1" ];then #SCP
                execscp $SERVER $SERVERIP $SYSTEMOS $LOCATION $USER $USERPASSWORD $ROOTPASSWORD
        elif [ "$OPTION" -eq "2" ];then #SCP reverso (scp desde servidor)
                execscp_reverso $SERVER $SERVERIP $SYSTEMOS $LOCATION $USER $USERPASSWORD $ROOTPASSWORD
        elif [ "$OPTION" -eq "3" ];then #SSH con expect
                execsshexpect $SERVER $SERVERIP $SYSTEMOS $LOCATION $USER $USERPASSWORD $ROOTPASSWORD
        elif [ "$OPTION" -eq "4" ];then #Scp con expect
                execscpexpect $SERVER $SERVERIP $SYSTEMOS $LOCATION $USER $USERPASSWORD $ROOTPASSWORD   
        elif [ "$OPTION" -eq "5" ];then #Scp con expect reverso
                execscpexpect_reverso $SERVER $SERVERIP $SYSTEMOS $LOCATION $USER $USERPASSWORD $ROOTPASSWORD   
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
        echo -en '\E[47;31m'"\033[1m ERROR - Chequea los parametros ingresados \033[0m\n"
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
elif [ "$1" = "-e" ]; then
        shift; OPTION=3
elif [ "$1" = "-E" ]; then
        shift; OPTION=4
elif [ "$1" = "-Er" ]; then
        shift; OPTION=5
else
        echo -en '\E[47;31m'"\033[1m ERROR - Chequea la opcion [-s/-S/-e/E] \033[0m\n"
        ayuda
fi

#### Lectura listado de ips y ejecucion
for line in $(cat $FILE)
do
        if [[ $line =~ "#" ]];then
                continue
        else
                getos $(echo $line | cut -d'|' -f1) $(echo $line | cut -d'|' -f2) $(echo $line | cut -d'|' -f3) $(echo $line | cut -d'|' -f4) $(echo $line | cut -d'|' -f5) $(echo $line | cut -d'|' -f6) $(echo $line | cut -d'|' -f7)
        fi
done
exit 0
