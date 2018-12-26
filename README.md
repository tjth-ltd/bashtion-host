# bashtion-host
An SSH Bastion server running in Docker for managing SSH connections

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
* Update users with appropriate user names for your users
* Update hosts with your server names / IPs should be used in hostname field if DNS is not configured completely

# Logging
* Logging is set to mount to the host, you can adjust the mounted directory in the docker-compose.yml file
* A random string is added to the end of the logfile name to ensure this cannot be guessed on the host system

NOTE: This is still a WIP - Be kind!
