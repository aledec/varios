#!/usr/bin/bash

DATE=`date +%Y%m%d`
TMPFILE=tmp/$0.tmp
STORAGEUNITSTEXFILE=output/StorageUnits_$(hostname)_$DATE.tex

  cat conf/encabezado_latex.tex > $STORAGEUNITSTEXFILE
  /usr/openv/netbackup/bin/admincmd/bpstulist -U > $TMPFILE
sleep 2
  echo "\newline" >> $STORAGEUNITSTEXFILE
  echo "* Listado de Storage Units del servidor $(hostname)" >> $STORAGEUNITSTEXFILE
  echo "\newline" >> $STORAGEUNITSTEXFILE
  echo "* Informacion Tecnica:" >> $STORAGEUNITSTEXFILE
  echo "\begin{verbatim}" >> $STORAGEUNITSTEXFILE
    cat $TMPFILE >> $STORAGEUNITSTEXFILE
  echo "\end{verbatim}" >> $STORAGEUNITSTEXFILE
  echo "\end{document}" >> $STORAGEUNITSTEXFILE
