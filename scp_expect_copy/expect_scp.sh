#!/usr/bin/expect -f
set password [lrange $argv 0 0]
set pathorigen [lrange $argv 1 1]
set pathdestino [lrange $argv 2 2]
set ipaddr [lrange $argv 3 3]
set timeout 10
#log_user 0
#spawn ssh -o "StrictHostKeyChecking no" SE16988A@$ipaddr 
spawn scp -rp SE16988A@$ipaddr:$pathorigen $pathdestino
expect "*?assword:*"
send -- "$password\r"
expect "$ "
