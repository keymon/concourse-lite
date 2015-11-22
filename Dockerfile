FROM ubuntu:15.10

# add sources for virtualbox
RUN echo 'deb http://archive.ubuntu.com/ubuntu/ wily multiverse' >> /etc/apt/sources.list
RUN echo 'deb-src http://archive.ubuntu.com/ubuntu/ wily multiverse' >> /etc/apt/sources.list

# virtualbox           : for building the images
# unzip                : for installing packer
# golang git mercurial : for building packer-bosh
RUN apt-get update && apt-get -y install virtualbox unzip golang git mercurial

# set up directories/env for packer + packer-bosh
RUN mkdir -p /opt/local/bin /opt/local/go
ENV GOPATH /opt/local/go
ENV PATH /opt/local/bin:/opt/local/go/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# install packer
ADD https://dl.bintray.com/mitchellh/packer/packer_0.7.2_linux_amd64.zip /tmp/packer.zip
RUN unzip -d /opt/local/bin /tmp/packer.zip && rm /tmp/packer.zip

# install and configure packer-bosh provisioner
ADD box-setup/install-packer-bosh /tmp/install-packer-bosh
ADD box-setup/packerconfig /opt/local/packerconfig
RUN /tmp/install-packer-bosh /opt/local/bin && rm /tmp/install-packer-bosh
ENV PACKER_CONFIG /opt/local/packerconfig
