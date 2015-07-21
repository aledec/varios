#!/usr/bin/bash

DATE=`date +%Y%m%d`
TMPFILE=tmp/$0.tmp
POLICYFILE=tmp/Policies_$(hostname).tmp
PDFTEXFILE=output/Policies_$(hostname)_$DATE.tex

cat conf/encabezado_latex.tex > $PDFTEXFILE
for i in $(bppllist -U| awk '{print $2'});do
bppllist $i -U > $POLICYFILE
  # Genero el output del ultimo export realizado desde la herramienta de backups
  egrep 'Type:|Storage Unit:|Volume Pool:|Ative:|Effective Date:|Compression:|Schedule:|Clients:|Solaris|Backup Selections:|Start Windows:|Monday|Tuesday|Wednesday|Thursday|Friday|Saturday|Sunday|/' $POLICYFILE > $TMPFILE

  echo "\newline" >> $PDFTEXFILE
  echo "* Informacion General - $(hostname)" >> $PDFTEXFILE
    echo "\begin{verbatim}" >> $PDFTEXFILE
    echo "Nombre De Politica: $i" >> $PDFTEXFILE
    echo "Politica Activa: $(grep 'Active:' $POLICYFILE| tr -d ' ' | awk -F: '{print $2}' | sed 's/Yes/Si/')" >> $PDFTEXFILE
    echo "Clientes: $(grep 'Solaris' $POLICYFILE| awk '{print $4}')" >> $PDFTEXFILE
  echo "\end{verbatim}" >> $PDFTEXFILE

  echo "\newline" >> $PDFTEXFILE
  echo "\newline" >> $PDFTEXFILE
  echo "* Informacion Tecnica:" >> $PDFTEXFILE
  echo "\begin{verbatim}" >> $PDFTEXFILE
    cat $TMPFILE >> $PDFTEXFILE
  echo "\end{verbatim}" >> $PDFTEXFILE
  echo "\newpage" >> $PDFTEXFILE

done

echo "\end{document}" >> $PDFTEXFILE
