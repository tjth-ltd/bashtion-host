#!/bin/bash

echo "Enter the new username for the new user:"
  read user
  # Check to see if the user exists in htpasswd already
  if [[ $(cat /etc/passwd) == *"$user":* ]];then
    exists="yes"
    read -p "This user already exists, would you like to update their password (y/n)?" yn
    case $yn in
        # If yes, continue. Else, exit
        [Yy]* ) ch="yes";;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
  else
    :
  fi
echo "Now the password (Less than 8 characters)?"
  read passwd

# Create the User
  echo "Now creating the User"
# Create the User if they do not exist
  if [[ $exists != "yes"  ]];then
	adduser --disabled-password --gecos "" $user
  fi
# Set the password
  echo "$user:$passwd" | chpasswd
# Restrict command running
chsh -s /bin/rbash $user
mkdir /home/"$user"/bin
chmod 755 /home/"$user"/bin
echo "PATH=/home/"$user"/bin" >> /home/"$user"/.bashrc
echo "export PATH" >> /home/"$user"/.bashrc
ln -s /scripts/bashtion.sh /home/"$user"/bin
ln -s /bin/ls /home/"$user"/bin
ln -s /bin/cd /home/"$user"/bin
ln -s /bin/cat /home/"$user"/bin
ln -s /scripts/sshwrapper.sh /home/"$user"/bin
