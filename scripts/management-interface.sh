#!/bin/bash
###
## INSTALLING & CONFIGURING MULTICHAIN WEB DEMO (AKA Management Interface)
###
git clone https://github.com/MultiChain/multichain-web-demo.git

# Configuring Web Demo
sudo bash -c 'cp /var/www/html/multichain-web-demo/config-example.txt /var/www/html/multichain-web-demo/config.txt'
sudo sed -ie 's/default.name=.*\#/default.name='$adminNodeName'       \#/g' /var/www/html/multichain-web-demo/config.txt
sudo sed -ie 's/default.rpcuser=.*\#/default.rpcuser='$rpcuser'       \#/g' /var/www/html/multichain-web-demo/config.txt
sudo sed -ie 's/default.rpcpassword=.*\#/default.rpcpassword='$rpcpassword'       \#/g' /var/www/html/multichain-web-demo/config.txt
sudo sed -ie 's/default.rpcport=.*\#/default.rpcport='$rpcport'       \#/g' /var/www/html/multichain-web-demo/config.txt
