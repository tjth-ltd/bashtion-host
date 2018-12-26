# bashtion-host
An SSH Bastion server running in Docker for managing SSH connections.

NOTE: This is still a WIP - Be kind! This is not to be used in a production environment yet.

# Features
* Fully bash-based code
* Create users to access via password or ssh-key pair (Uploading public key to the container)
* Retain users after server restarts *WIP*

# Installation
* Clone the repository to your Bashtion server
* Build the container:
```
docker-compose up -d --build
```

# Configuration
* Copy the defaults config file (config/bashtion.json.defaults) to a new file (config/bashtion.json)
* Update the server details (Server Name and Admin Email address)
* Update User Groups with appropriate group names
* Update users with appropriate user names for your users *Adding users will be included in the add-user script at a later date*
* Update hosts with your server names / IPs should be used in hostname field if DNS is not configured completely *I will be adding a script to add hosts at a later date*

# Adding Users
* Run the below command to create a user within the container. Follow prompts to create users
```
docker exec -it bashtionhost_ssh-bastion_1 /scripts/add-user.sh
```
* Ensure the user is setup in the config file or they will recieve an error on login.

# Logging
* Logging is set to mount to the host, you can adjust the mounted directory in the docker-compose.yml file
* A random string is added to the end of the logfile name to ensure this cannot be guessed on the host system

# Upcoming Features
* Updating config file with new users via add-user.sh script
* Script to add hosts / groups
* Retain password connecting users over container restarts (Or drop password connections.. To be decided)

