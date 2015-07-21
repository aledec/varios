#!/usr/bin/bash

DATE=`date +%Y%m%d`
TMPFILE=tmp/$0.tmp
TAPESTEXFILE=output/Tapes_$(hostname)_$DATE.tex

  cat conf/encabezado_latex.tex > $TAPESTEXFILE
/usr/openv/volmgr/bin/vmquery -rn 0 -bx | sort +13 > $TMPFILE

  echo "\newline" >> $TAPESTEXFILE
  echo "* Listado de Cintas del servidor $(hostname)" >> $TAPESTEXFILE
  echo "\newline" >> $TAPESTEXFILE
  echo "* Informacion Tecnica:" >> $TAPESTEXFILE
  echo "\begin{verbatim}" >> $TAPESTEXFILE
    cat $TMPFILE >> $TAPESTEXFILE
  echo "\end{verbatim}" >> $TAPESTEXFILE
  echo "\end{document}" >> $TAPESTEXFILE
