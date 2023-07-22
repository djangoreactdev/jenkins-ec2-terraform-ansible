# FROM jenkins/jenkins:lts
# USER root
# RUN apt-get update -qq \
#     && apt-get install -qqy apt-transport-https ca-certificates curl gnupg2 \
#     software-properties-common
# RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
# RUN add-apt-repository \
#    "deb [arch=amd64] https://download.docker.com/linux/debian \
#    $(lsb_release -cs) \
#    stable"
# RUN apt-get update  -qq \
#     && apt-get -y install docker-ce
# RUN usermod -aG docker jenkins

# RUN apt-get install -y ansible

# RUN wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
# RUN echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list
# RUN apt-get update && apt-get install terraform

# RUN curl -SL https://github.com/docker/compose/releases/download/v2.20.0/docker-compose-linux-{{lookup('pipe', 'uname -m')}} \
# -o ~/.docker/cli-plugins/docker-compose
# RUN chmod +x ~/.docker/cli-plugins/docker-compose
# RUN chmod 666 /var/run/docker.sock

# Using an official Python runtime as a parent image
FROM jenkins/jenkins:lts

# Switching to root user to install ansible, docker, docker-compose and terraform
USER root

# Installing Ansible
RUN apt-get update && \
    apt-get install -y ansible wget unzip

# Installing Docker CLI
RUN curl -fsSL https://get.docker.com -o get-docker.sh && \
    sh get-docker.sh

RUN usermod -aG docker jenkins

# Installing Docker Compose
RUN curl -L "https://github.com/docker/compose/releases/download/v2.20.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose

# Installing Terraform
RUN wget https://releases.hashicorp.com/terraform/1.5.3/terraform_1.5.3_linux_amd64.zip && \
    unzip terraform_1.5.3_linux_amd64.zip && \
    mv terraform /usr/local/bin/

# Switching back to the jenkins user
USER jenkins
