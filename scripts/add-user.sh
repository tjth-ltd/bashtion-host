#!/bin/bash

siteAdmin=$(cat /etc/bashtion/bashtion.json | jq -r ".server[] | .siteadmin")

echo "Enter the new username for the new user:"
  read user
  # Check to see if the user exists in htpasswd already
  if [[ -d /home/"$user" ]];then
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
  read -p "Would you like to use Password authentication (Otherwise, public SSH key will be required) (y/n)?" ynp
    case $ynp in
        # If yes, continue. Else, exit
        [Yy]* ) pass="yes";;
        [Nn]* ) pass="no";;
        * ) echo "Please answer yes or no.";;
    esac

if [[ $pass = "yes" ]];then
	echo "Now the password (Less than 8 characters)?"
	read passwd
else
	# Randomly Generate password (50 Characters)
	passwd=$(date +%s | sha256sum | base64 | head -c 50 ; echo)
	echo "Please enter the user's public SSH key"
	read pubkey
fi

# Create the User
  echo "Now creating the User"
# Create the User if they do not exist
  if [[ $exists != "yes"  ]];then
	adduser --disabled-password --gecos "" $user
  fi
# Set the password
  echo "$user:$passwd" | chpasswd
# Create .ssh directory
  mkdir /home/"$user"/.ssh
  chmod 755 /home/"$user"/.ssh/

# If Public ssh key was chosen, create authorized_keys file
  if [[ $pass = "no"  ]];then
	echo "$pubkey" >> /home/"$user"/.ssh/authorized_keys
	chmod 644 /home/"$user"/.ssh/authorized_keys
  else
	:
  fi

# Generate public ssh-key for new user
ssh-keygen -t rsa -f /home/"$user"/.ssh/id_rsa -q -N ""
chmod 600 /home/"$user"/.ssh/id_rsa.pub
chmod 755 /home/"$user"/.ssh/
chown -R "$user":"$user" /home/"$user"/.ssh

# Print public key for Administrator
echo "pubic key for $user: $(cat /home/"$user"/.ssh/id_rsa.pub)"

# Restrict command running
mkdir /home/"$user"/bin
chmod 755 /home/"$user"/bin
echo "PATH=/home/"$user"/bin" >> /home/"$user"/.bashrc
echo "export PATH" >> /home/"$user"/.bashrc
ln -s /bin/bashtion.sh /home/"$user"/bin
ln -s /bin/ls /home/"$user"/bin
ln -s /usr/bin/clear_console /home/"$user"/bin
ln -s /bin/cd /home/"$user"/bin
ln -s /bin/ps /home/"$user"/bin ## TEMP
ln -s /bin/grep /home/"$user"/bin ## TEMP
ln -s /bin/cat /home/"$user"/bin
ln -s /scripts/sshwrapper.sh /home/"$user"/bin
chsh -s /bin/rbash $user
#chsh -s /scripts/sshwrapper.sh $user
