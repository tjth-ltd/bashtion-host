#!/bin/bash

# Variables
conf="/etc/bashtion/bashtion.json"
srvList="/tmp/server-list.txt"

# Get User's Groups
groups=$(cat $conf | jq -r ".users[] | select(.username=="\"$(whoami)"\") | .usergroups[]")

# Get servers in Groups
for group in $groups; do
cat $conf | jq ".hosts[] | select(.usergroups[]=="\"$group"\") | .name" >> $srvList
done

# Format server list with numbers prepended
list=$(nl -w1 -nrz $srvList)

echo $list

# Generate list
choice=$(dialog --clear --backtitle "Server Connection" --title "Server List" --menu "Which Server would you like to connect to?" 15 40 4 \
        $list 2>&1 >/dev/tty)

rm -rf /tmp/server-list.txt

exit
