scp root@server01:/home/admins/Mariano/netbackup_inventory/output/*$(date +%Y%m%d)* .
for i in $(ls *$(date +%Y%m%d.tex));do echo R|pdflatex $i;done
