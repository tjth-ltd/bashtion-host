#!/bin/bash

choice=$(dialog --clear --backtitle "Server Connection" --title "Server List" --menu "Which Server would you like to connect to?" 15 40 4 \
        1 "hvm-monit" \
        2 "hvm-dc" 2>&1 >/dev/tty)

# Exit if cancel pressed
    if [ $? -ne 0 ]; then
        exit;
    fi;

case $choice in
	1) 
	user="root"
	server="hvm-monit"
	;;
	2)
	user="root"
	server="hvm-dc"
	;;
esac

ssh "$user"@"$server"
exit
