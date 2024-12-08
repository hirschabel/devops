FROM jenkins/jenkins:lts

USER root

RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    gnupg \
    software-properties-common \
    lsb-release \
    apt-transport-https \
    ca-certificates \
    sudo

RUN curl -fsSL https://get.docker.com | sh

RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | tee /etc/apt/trusted.gpg.d/hashicorp.asc
RUN echo "deb https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list

RUN apt-get update && apt-get install -y terraform

WORKDIR /workspace
