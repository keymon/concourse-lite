#!/bin/bash

set -x

useradd vagrant
echo "vagrant:vagrant" | chpasswd

echo 'vagrant' | sudo -S usermod -a -G admin vagrant
