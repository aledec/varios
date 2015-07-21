#!/usr/bin/bash

DATE=`date +%Y%m%d`
TMPFILE=tmp/$0.tmp
CLIENTSTEXFILE=output/Clients_$(hostname)_$DATE.tex

  cat conf/encabezado_latex.tex > $CLIENTSTEXFILE
bpplclients -allunique -U > $TMPFILE

  echo "\newline" >> $CLIENTSTEXFILE
  echo "* Listado de Clientes del servidor $(hostname)" >> $CLIENTSTEXFILE
  echo "\newline" >> $CLIENTSTEXFILE
  echo "* Informacion Tecnica:" >> $CLIENTSTEXFILE
  echo "\begin{verbatim}" >> $CLIENTSTEXFILE
    cat $TMPFILE >> $CLIENTSTEXFILE
  echo "\end{verbatim}" >> $CLIENTSTEXFILE
  echo "\end{document}" >> $CLIENTSTEXFILE
