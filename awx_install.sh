#!/usr/bin/env bash

# Install packages required to setup AWX
sudo yum -y install epel-release
sudo yum -y update all
sudo yum -y install -y wget git gettext ansible docker nodejs npm gcc-c++ bzip2 vim

sudo yum -y install python34-setuptools
alias python=/usr/local/bin/python2.7
pip install docker
pip install docker-compose

# Creating the docker storage setup to ensure we have a docker thin pool 
cat <<EOF > /etc/sysconfig/docker-storage-setup
# DEVS=/dev/xvdf
DEVS=/dev/xvda
VG=docker-vg
EOF

# Configuring and installating Docker
docker-storage-setup

# Restart docker and go to clean state as required by docker-storage-setup.
systemctl stop docker
rm -rf /var/lib/docker/*
systemctl start docker
systemctl enable docker

# Downloading the awx repo
git clone https://github.com/ansible/awx.git /tmp/awx_repo

# Install AWX
ansible-playbook -i /tmp/awx_repo/installer/inventory /tmp/awx_repo/installer/install.yml
