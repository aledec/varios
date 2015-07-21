#!/bin/bash

LOG=/monitoreo.log
SERVERLIST=/serverlist.txt
fecha=$(date +%Y-%m-%d.%H:%M:%S)

SENDEMAIL="sendEmail.pl"
MAILSERVER="smtp" #SMTP Server
EMAILCRITICO="mariano.a.luna@"
EMAILNORMAL="mariano.a.luna@"

notifyme(){
	CRITICAL="$1"
        MAILSUBJECT="$2"
        MAILMESSAGE="$3"
	echo "$CRITICAL - $MAILSUBJECT" >> $LOGFILE
	if [ $CRITICAL -gt 1 ]; then
		MAILTO=$EMAILCRITICO
	else
		MAILTO=$EMAILNORMAL
	fi
        ./$SENDEMAIL -f "$FROMADRESS" -t "$MAILTO" -u "$MAILSUBJECT" -m "$MAILMESSAGE" -s $MAILSERVER >> $LOGFILE
}

##check if host is alive or not
isalive(){
target=$1
COUNT=$(ping -c 3 $target | grep icmp | grep -v grep | wc -l)
if [ $COUNT -eq 0 ]; then
	MESSAGE="MONITOREO: $target se encuentra con timeouts en solicitudes ping $fecha"
	CONTENT="El host $i no ha respondido solciiteudes icmp en la fecha $fecha"
        notifyme $EMAILNORMAL "$MESSAGE" "$CONTENT"
elif [ $COUNT -lt 3 ]; then
	MESSAGE="MONITOREO: $target se encuentra con timeouts en solicitudes ping $fecha"
	CONTENT="El host  $i solo ha respondido $COUNT solicitudes icmp en la fecha $fecha"
	notifyme $EMAILNORMAL "$MESSAGE" "$CONTENT"
fi
}

isportopen(){
target=$1
port=$2
desc=$3
STATUS=$(nc -z -w3 $target $port)
if [ $? -ne 0]; then
	MESSAGE="MONITOREO: $target puerto $port no se encuentra disponible"
	CONTENT="En fecha $fecha $target : $port no se encuentra disponible. Descripcion $desc"
	notifyme $EMAILNORMAL "$MESSAGE" "$CONTENT"
fi
}

while read line; do
	isalive $(echo $line | awk '{print $1}')
	isportoopen $(echo $line | awk '{print $1}') $(echo $line | awk '{print $2}') $(echo $line | awk '{print $3}')
done < <(cat $LISTA_EQUIPOS|grep -v "###")

