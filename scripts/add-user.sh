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
