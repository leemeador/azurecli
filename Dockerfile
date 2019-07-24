FROM debian:jessie

RUN rm /bin/sh && ln -s /bin/bash /bin/sh

ENV AZURE_CLI_VERSION "0.10.13"
ENV NODEJS_APT_ROOT "node_6.x"
ENV NODEJS_VERSION "6.10.0"

RUN apt-get update -qq && \
  apt-get install -qqy --no-install-recommends\
  apt-transport-https \
  build-essential \
  curl \
  ca-certificates \
  git \
  lsb-release \
  python-all \
  rlwrap \
  vim \
  nano \      
  jq && \
  rm -rf /var/lib/apt/lists/* && \
  curl https://deb.nodesource.com/${NODEJS_APT_ROOT}/pool/main/n/nodejs/nodejs_${NODEJS_VERSION}-1nodesource1~jessie1_amd64.deb > node.deb && \
  dpkg -i node.deb && \
  rm node.deb && \
  npm install --global azure-cli@${AZURE_CLI_VERSION} && \
  azure --completion >> ~/azure.completion.sh && \
  echo 'source ~/azure.completion.sh' >> ~/.bashrc && \
  azure

RUN azure config mode arm

ENV EDITOR vim

RUN echo "deb [check-valid-until=no] http://cdn-fastly.deb.debian.org/debian jessie main" > /etc/apt/sources.list.d/jessie.list
RUN echo "deb [check-valid-until=no] http://archive.debian.org/debian jessie-backports main" > /etc/apt/sources.list.d/jessie-backports.list
RUN sed -i '/deb http:\/\/deb.debian.org\/debian jessie-updates main/d' /etc/apt/sources.list
RUN apt-get -o Acquire::Check-Valid-Until=false update

RUN apt-get install -y -t jessie-backports openjdk-8-jdk ca-certificates-java



# Setup JAVA_HOME
# ENV JAVA_HOME /usr/bin
# RUN export JAVA_HOME