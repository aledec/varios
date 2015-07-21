#!/usr/bin/bash

DATE=`date +%Y%m%d`
TMPFILE=tmp/$0.tmp
VOLUMEPOOLTEXFILE=output/VolumePool_$(hostname)_$DATE.tex

  cat conf/encabezado_latex.tex > $VOLUMEPOOLTEXFILE
  /usr/openv/volmgr/bin/vmpool -listall -bx > $TMPFILE 
  echo "\newline" >> $VOLUMEPOOLTEXFILE
  echo "* Listado de Volume Pools del servidor $(hostname)" >> $VOLUMEPOOLTEXFILE
  echo "\newline" >> $VOLUMEPOOLTEXFILE
  echo "* Informacion Tecnica:" >> $VOLUMEPOOLTEXFILE
  echo "\begin{verbatim}" >> $VOLUMEPOOLTEXFILE
    cat $TMPFILE >> $VOLUMEPOOLTEXFILE
  echo "\end{verbatim}" >> $VOLUMEPOOLTEXFILE
  echo "\end{document}" >> $VOLUMEPOOLTEXFILE
