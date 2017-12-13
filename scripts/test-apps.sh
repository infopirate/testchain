#!/bin/bash
###
## INSTALLING & CONFIGURING TESTAPPS
###
git clone https://github.com/unibitlabs/uniapps.git

# Configuring Uniapps
sudo sed -ie 's/$CHAIN_NAME =.*;/$CHAIN_NAME = "'$chainname'";/g' /var/www/html/uniapps/config.php
sudo sed -ie 's/RPC_USER =.*;/RPC_USER = "'$rpcuser'";/g' /var/www/html/uniapps/config.php
sudo sed -ie 's/RPC_PASSWORD =.*;/RPC_PASSWORD = "'$rpcpassword'";/g' /var/www/html/uniapps/config.php
sudo sed -ie 's/RPC_PORT =.*;/RPC_PORT = "'$rpcport'";/g' /var/www/html/uniapps/config.php
sudo sed -ie 's/MANAGER_ADDRESS =.*;/MANAGER_ADDRESS = "'$addr'";/g' /var/www/html/uniapps/config.php
