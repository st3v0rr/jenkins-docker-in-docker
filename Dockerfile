FROM jenkins/jenkins:lts

USER root

#jenkins user-id from host - check with "cat /etc/passwd | grep jenkins"
ARG HOST_UID=1004
#docker group-id from host - check with "cat /etc/group | grep docker"
ARG HOST_GID=281

#install docker
RUN apt-get update && \
apt-get -y install apt-transport-https \
                   ca-certificates \
                   curl \
                   gnupg2 \
                   software-properties-common && \
curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg > /tmp/dkey; apt-key add /tmp/dkey && \
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
   $(lsb_release -cs) \
   stable" && \
apt-get update && \
apt-get -y install docker-ce

#cleanup
RUN rm -rf /var/lib/apt/lists/*

#permit jenkins user access to docker group
RUN usermod -u $HOST_UID jenkins && \
    groupmod -g $HOST_GID docker && \
    usermod -aG docker jenkins

USER jenkins