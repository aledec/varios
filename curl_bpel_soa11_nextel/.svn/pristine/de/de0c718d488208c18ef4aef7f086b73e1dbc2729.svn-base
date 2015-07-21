#!/bin/bash 

### Archivo a leer listado de ordenes
ORDERFILE="$0.txt"

### Archivos temporales de error
RETURNFILE="$0.tmp"
OUTFILE="$0.out"
ERRORFILE="$0.err"

#ERRORMESSAGE="$0.err"

##INITIALIZEME
STATUS=0

###########################################################################
#### FUNCIONES
###########################################################################

#### Mostrar ayuda
function ayuda ()
{
        echo "Uso: $0"
        exit 2
}

#### Limpiar archivos temporales
function cleanall ()
{
touch $ERRORFILE
touch $OUTFILE
#  rm -f $RETURNFILE
  STATUS=0
}

function mostrar ()
{
ORDERNUMBER=$1
ORDERSTATUS=$2
ERRORMESSAGE=$3
echo "$ORDERNUMBER | $ORDERSTATUS | $ORDERERROR"
}

function runrun ()
#recibo de parametros $1 - numero de orden; 
{
ORDERNUMBER=$1
STATUS=0
ERRORMESSAGE=""
  cat $OUTFILE | while read line; do

    
    #Codigos de error - ok=0; warning=1; critical=2; unknown=3
    if [ $(echo $line | tr -d ' ' | tr -d '\t') = 'Faulted' ];then
      STATUS=1
    elif [ $(echo $line | tr -d ' ' | tr -d '\t') = 'Critical' ];then
      STATUS=2
    elif [ $(echo $line | tr -d ' ' | tr -d '\t') = 'Completed' ]; then
      STATUS=0
    fi
    echo $STATUS
    if [ $STATUS -ge 0 ];
      then
      echo $line
	ERRORMESSAGE="$line $(cat $ERRORFILE)"
	STATUS=0 #reseteo la variable de status para poder seguir usandolo
	  echo "$ERRORMESSAGE" > "$ERRORFILE"
    fi   

  done
  
  #if [ -n "$ERRORMESSAGE" ];then
      if [ $(wc -c "$OUTFILE") -ge 1 ];then
	ORDERSTATUS="Order does not arrive SOA"
      elif [ $(egrep -i 'faulted|critical|completed' $OUTFILE | wc -l) -ne $(egrep -iv 'faulted|critical|completed' $OUTFILE | wc -l) ];then
	ORDERSTATUS="Order is in process"
      elif [ $STATUS -eq 2 ];then
	ORDERSTATUS="Order has Failed in SOA"
      else
	ORDERSTATUS="Order is completed"
      fi
  #fi
  mostrar $ORDERNUMBER "$ORDERSTATUS" $(cat "$ERRORFILE")
}

###########################################################################
#### CONDICIONALES
###########################################################################

#### Condicional ayuda
if [ $# -ge 1 ]; then
        echo "ERROR - Chequea los parametros ingresados - No hay parametros"
        ayuda
fi

for i in $(cat $ORDERFILE);do 
  php -f write.php $i
    egrep "<img src='images/fault.gif' alt='Faulted'>|<img src='images/normal.gif' alt='Completed'>|displayInstance.jsp?referenceId=bpel://localhost/default/|$i</a>" $RETURNFILE | tr -d "'" |tr -d "=" | tr -d "/" | sed 's/<a>//' | tr -d "<>" | tr -d "#" | sed 's/img srcimagesnormal.gif alt//' | sed 's/img srcimagesfault.gif alt//' | uniq > $OUTFILE
  runrun $i
  cleanall
done
