#!/bin/bash

# Variables
conf="/etc/bashtion/bashtion.json"
suffix=$(mktemp -u XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX)
srvList="/tmp/server-list-$suffix.txt"

# Get User's Groups
groups=$(cat $conf | jq -r ".users[] | select(.username=="\"$(whoami)"\") | .usergroups[]")

# Get servers in Groups
for group in $groups; do
	cat $conf | jq -r ".hosts[] | select(.usergroups[]=="\"$group"\") | .name" >> $srvList
done

# Format server list for Dialog (Duplicate text on each line)
sed -i -r 's/(\S+)/\1 \1/g' $srvList
list=$(cat $srvList)

# Generate list
choice=$(dialog --clear --backtitle "Server Connection" \
                --title "Server List" \
                --menu "Which Server would you like to connect to?" 15 40 6 \
                $list 2>&1 >/dev/tty)
# Retreive choice exit code
choiceVal=$?

# Proceed based on option selected
case $choiceVal in
	0)
		user=$(cat $conf | jq -r ".hosts[] | select(.name=="\"$choice"\") | .sshuser")
		clear
		ssh $user@"$choice"
		;;
	1)
		echo "Cancel pressed.";;
	255)
		echo "ESC pressed.";;
esac

# Cleanup
rm -rf /tmp/server-list.txt
exit
