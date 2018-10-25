FROM ubuntu:16.04

# Install Openssh-server and configure
RUN apt-get update && apt-get install -y openssh-server
RUN mkdir /var/run/sshd
RUN echo 'root:screencast' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -i 's/Port 22/Port 2201/' /etc/ssh/sshd_config

# Install Dialog for Bastion Choice
RUN apt-get install -y dialog

# Install jq for Json parsing
RUN apt-get install -y jq

# Run bastion script on login
RUN echo "Match Group *,!root" >> /etc/ssh/sshd_config
RUN echo "ForceCommand /scripts/bashtion.sh"

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

EXPOSE 2201
CMD ["/usr/sbin/sshd", "-D"]
