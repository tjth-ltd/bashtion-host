#!/bin/bash

serverName=$(cat /etc/bashtion/bashtion.json | jq -r ".server[] | .servername")

# Variables
user=$(whoami)
logFile="$user-$(date +%F)"
tmpDir="/tmp/"
logDir="/var/log/bastion/"
suffix=$(mktemp -u XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX)
conf="/etc/bashtion/bashtion.json"

# Error if config file does not exist
if [[ ! -f "$conf"  ]];then
	echo "Bashtion is not configured"
	exit 1
else
	:
fi

# Error and exit if user not configured in Bashtion
if [[ $(cat "$conf" | jq -r ".users[] | select(.username=="\"$(whoami)"\")") == *"$(whoami)"* ]]; then
        :
else
        echo "User $(whoami) not configured in Bashtion"
        exit 1
fi

# Welcome message
dialog --title "Welcome to $serverName" --clear \
        --yesno "Your connection and sesion will be logged and audited. (Log file: $logFile) Do you accept?" 10 50

case $? in
        0)
                dialog --infobox "Okay, go with caution.." 10 30 ; sleep 1
		script -qf --timing="$tmpDir""$logFile""$suffix".timing "$logDir""$logFile""$suffix".log --command=bashtion.sh
                ;;
        1)
                dialog --infobox "So be it.." 10 30 ; sleep 1
                exit 1
                ;;
        255)
                echo "ESC pressed."
		exit
		;;
esac

