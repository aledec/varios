#!/usr/bin/expect -f
set password [lrange $argv 0 0]
set ipaddr [lrange $argv 1 1]
set timeout 120
#log_user 0
spawn ssh -o "StrictHostKeyChecking no" SE16988A@$ipaddr 
expect "*?assword:*"
send -- "$password\r"
#log_user 1
expect "$ "
send "echo 'texttoremove'\r"
expect "$ "
send "cd /controlm/ctmag/tsm/log/\r"
expect "$ "
#send "cat $(ls -1 | grep SEMANAL | tail -1) | tail -1\r"
#send "tail -1 *SEMANAL* | awk '{print $3 " " $20}'\r"
send "ls -1tr *SEMAN* | tail -1 | xargs -n 1 tail -1\r"
#send "cat /controlm/ctmag/tsm/log/$(ls -1 /controlm/ctmag/tsm/log/ | grep SEMANAL | tail -1) | tail -1\r"
expect "$ "
#send "ps -ef | grep dw\r"
#bsend "uname -a\r"
#send "uname -a\r"
#send "cat /controlm/ctmag/tsm/log/$i | tail -1"
#expect "$ "
send "exit\r"
#send -- "\r"
#expect eof
