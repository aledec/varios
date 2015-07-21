cat backups.txt|grep -i sua|sed 's/----------------------------------->//'|sed 's/-------------------------------------//'|sed 's/\#//'|awk '{print $1}'|sort|awk -F@ '{print $1}'|uniq > equipos.txt
