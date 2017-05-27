#!/bin/bash

echo -n "Enter the desired admin username and press [ENTER]: "
read username
echo -n "Enter admin's first name and press [ENTER]: "
read firstname
echo -n "Enter admin's last name and press [ENTER]: "
read lastname
echo -n "Enter admin's email address and press [ENTER]: "
read email
echo -n "Enter admin's password and press [ENTER]: "
read password
echo -n "Enter the organisation name and press [ENTER]: "
read company_name
echo -n "Enter a lower-case organisation code and press [ENTER]: "
read lcase_company

# Install rmate
sudo wget -O /usr/local/bin/rmate https://raw.github.com/aurora/rmate/master/rmate
sudo chmod a+x /usr/local/bin/rmate

# this is for chef-server on ubuntu 14-04
# from https://docs.chef.io/install_server.html
curl https://packages.chef.io/files/stable/chef-server/12.15.7/ubuntu/14.04/chef-server-core_12.15.7-1_amd64.deb --output /tmp/chef-server-core_12.15.7-1_amd64.deb
dpkg -i /tmp/chef-server-core_12.15.7-1_amd64.deb
sudo su -
chef-server-ctl reconfigure
chef-server-ctl user-create $username $firstname $lastname $email "$password" --filename ~/rsa_keys/$username.pem
chef-server-ctl org-create $lcase_company "$company_name" --association_user $username --filename ~/rsa_keys/$lcase_company-validator.pem

# Install chef-server manage
chef-server-ctl install chef-manage
chef-server-ctl reconfigure --accept-license
chef-manage-ctl reconfigure --accept-license

# Install chef-server push jobs server
chef-server-ctl install opscode-push-jobs-server
chef-server-ctl reconfigure
opscode-push-jobs-server-ctl reconfigure

# Install chef-server reporting
chef-server-ctl install opscode-reporting
chef-server-ctl reconfigure
opscode-reporting-ctl reconfigure
