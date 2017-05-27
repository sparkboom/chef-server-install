#!/bin/bash

echo -n "Enter the desired hostname and press [ENTER]: "
read hostname

sudo su -

# Install rmate
wget -O /usr/local/bin/rmate https://raw.github.com/aurora/rmate/master/rmate
chmod a+x /usr/local/bin/rmate

# Set hostname
echo "$hostname" > '/etc/hostname'

reboot
