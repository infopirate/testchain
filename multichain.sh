#!/bin/bash
# export TERM=xterm-color

# NC='\033[0m' # No Color
# RED='\033[0;31m'
# LIGHTGREEN='\033[1;32m'
# CYAN='\033[0;36m'
# LIGHTYELLOW='\033[1;33m'
# bold=$(tput bold)
# normal=$(tput sgr0)

chainname=$1
rpcuser=$2
rpcpassword=$3
assetName='yourcoin'
multichainVersion='2.0-alpha-1'
protocol=20001
networkport=61172
rpcport=15590
explorerport=2750
adminNodeName=$chainname'_Admin'
explorerDisplayName=$chainname
phpinipath='/etc/php/7.0/apache2/php.ini'
username='testuser'

echo '----------------------------------------'
echo -e 'INSTALLING PREREQUISITES.....'
echo '----------------------------------------'

cd .. 

sudo apt-get --assume-yes update
sudo apt-get --assume-yes install jq git vsftpd aptitude apache2-utils php-curl php7.0-curl sqlite3 libsqlite3-dev python-dev gcc python-pip
sudo pip install --upgrade pip

wget https://pypi.python.org/packages/60/db/645aa9af249f059cc3a368b118de33889219e0362141e75d4eaf6f80f163/pycrypto-2.6.1.tar.gz
tar -xvzf pycrypto-2.6.1.tar.gz
cd pycrypto*
sudo python setup.py install
cd ..

## Configuring PHP-Curl
sudo sed -ie 's/;extension=php_curl.dll/extension=php_curl.dll/g' $phpinipath

sudo service apache2 restart

echo ''
echo ''
echo '----------------------------------------'
echo ''
echo ''
echo ''
echo ''

sleep 3
echo '----------------------------------------'
echo -e 'CONFIGURING FIREWALL.....'
echo '----------------------------------------'

sudo ufw allow $networkport
sudo ufw allow $rpcport
sudo ufw allow $explorerport
sudo ufw allow 21

echo ''
echo ''
echo '----------------------------------------'
echo ''
echo ''
echo ''
echo ''

echo -e '----------------------------------------'
echo -e 'FIREWALL SUCCESSFULLY CONFIGURED!'
echo -e '----------------------------------------'

echo '----------------------------------------'
echo -e 'INSTALLING & CONFIGURING MULTICHAIN 2.0....'
echo '----------------------------------------'

sudo bash -c 'chmod -R 777 /var/www/html'
wget --no-verbose https://www.multichain.com/download/multichain-2.0-alpha-1.tar.gz
sudo bash -c 'tar xvf multichain-2.0-alpha-1.tar.gz'
sudo bash -c 'cp multichain-'$multichainVersion'*/multichain* /usr/local/bin/'

su -l $username -c  'multichain-util create '$chainname

su -l $username -c "sed -ie 's/.*root-stream-open =.*\#/root-stream-open = false     #/g' /var/www/html/.multichain/$chainname/params.dat"
su -l $username -c "sed -ie 's/.*admin-consensus-admin =.*\#/admin-consensus-admin = 0.0     #/g' /var/www/html/.multichain/$chainname/params.dat"
su -l $username -c "sed -ie 's/.*admin-consensus-activate =.*\#/admin-consensus-activate = 0.0     #/g' /var/www/html/.multichain/$chainname/params.dat"
su -l $username -c "sed -ie 's/.*admin-consensus-mine =.*\#/admin-consensus-mine = 0.0     #/g' /var/www/html/.multichain/$chainname/params.dat"
su -l $username -c "sed -ie 's/.*mining-requires-peers =.*\#/mining-requires-peers = true     #/g' /var/www/html/.multichain/$chainname/params.dat"
su -l $username -c "sed -ie 's/.*initial-block-reward =.*\#/initial-block-reward = 0     #/g' /var/www/html/.multichain/$chainname/params.dat"
su -l $username -c "sed -ie 's/.*first-block-reward =.*\#/first-block-reward = -1     #/g' /var/www/html/.multichain/$chainname/params.dat"
su -l $username -c "sed -ie 's/.*target-adjust-freq =.*\#/target-adjust-freq = 172800     #/g' /var/www/html/.multichain/$chainname/params.dat"
su -l $username -c "sed -ie 's/.*allow-min-difficulty-blocks =.*\#/allow-min-difficulty-blocks = true     #/g' /var/www/html/.multichain/$chainname/params.dat"
su -l $username -c "sed -ie 's/.*max-std-tx-size =.*\#/max-std-tx-size = 100000000     #/g' /var/www/html/.multichain/$chainname/params.dat"
su -l $username -c "sed -ie 's/.*max-std-op-returns-count =.*\#/max-std-op-returns-count = 1024     #/g' /var/www/html/.multichain/$chainname/params.dat"
su -l $username -c "sed -ie 's/.*max-std-op-return-size =.*\#/max-std-op-return-size = 8388608     #/g' /var/www/html/.multichain/$chainname/params.dat"
su -l $username -c "sed -ie 's/.*max-std-op-drops-count =.*\#/max-std-op-drops-count = 100     #/g' /var/www/html/.multichain/$chainname/params.dat"
su -l $username -c "sed -ie 's/.*max-std-element-size =.*\#/max-std-element-size = 32768     #/g' /var/www/html/.multichain/$chainname/params.dat"
su -l $username -c "sed -ie 's/.*default-network-port =.*\#/default-network-port = '$networkport'     #/g' /var/www/html/.multichain/$chainname/params.dat"
su -l $username -c "sed -ie 's/.*default-rpc-port =.*\#/default-rpc-port = '$rpcport'     #/g' /var/www/html/.multichain/$chainname/params.dat"
su -l $username -c "sed -ie 's/.*chain-name =.*\#/chain-name = '$chainname'     #/g' /var/www/html/.multichain/$chainname/params.dat"
# su -l $username -c " sed -ie 's/.*protocol-version =.*\#/protocol-version = '$protocol'     #/g' /var/www/html/.multichain/$chainname/params.dat"

su -l $username -c "echo rpcuser='$rpcuser' > /var/www/html/.multichain/$chainname/multichain.conf"
su -l $username -c "echo rpcpassword='$rpcpassword' >> /var/www/html/.multichain/$chainname/multichain.conf"
su -l $username -c 'echo rpcport='$rpcport' >> /var/www/html/.multichain/'$chainname'/multichain.conf'

echo ''
echo ''
echo '----------------------------------------'
echo ''
echo ''
echo ''
echo ''

echo '----------------------------------------'
echo -e 'RUNNING BLOCKCHAIN.....'
echo '----------------------------------------'

su -l $username -c 'multichaind '$chainname' -daemon'

echo ''
echo ''
echo '----------------------------------------'
echo ''
echo ''
echo ''
echo ''

echo '----------------------------------------'
echo -e 'LOADING Yourcoin CONFIGURATION.....'
echo '----------------------------------------'

sleep 6

addr=`curl --user $rpcuser:$rpcpassword --data-binary '{"jsonrpc": "1.0", "id":"curltest", "method": "getaddresses", "params": [] }' -H 'content-type: text/json;' http://127.0.0.1:$rpcport | jq -r '.result[0]'`

su -l $username -c  "multichain-cli "$chainname" issue "$addr" '{\"name\":\""$assetName"\", \"open\":true}' 1000000000000 0.01 0 '{\"description\":\"This is a smart asset for peer-to-peer transaction\"}'"


echo ''
echo ''
echo '----------------------------------------'
echo ''
echo ''
echo ''
echo ''


echo '----------------------------------------'
echo -e 'CREATING AND CONFIGURING STREAMS.....'
echo '----------------------------------------'


# CREATE STREAMS
# ------ -------
su -l $username -c "multichain-cli $chainname createrawsendfrom $addr '{}' '[{\"create\":\"stream\",\"name\":\"proof_of_existence\",\"open\":false,\"details\":{\"purpose\":\"Stores hashes of files\"}}]' send"

su -l $username -c  "multichain-cli "$chainname" createrawsendfrom "$addr" '{}' '[{\"create\":\"stream\",\"name\":\"users_credentials\",\"open\":false,\"details\":{\"purpose\":\"Stores Users Credentials\"}}]' send"
su -l $username -c  "multichain-cli "$chainname" createrawsendfrom "$addr" '{}' '[{\"create\":\"stream\",\"name\":\"users_details\",\"open\":false,\"details\":{\"purpose\":\"Stores Users Details\"}}]' send"
su -l $username -c  "multichain-cli "$chainname" createrawsendfrom "$addr" '{}' '[{\"create\":\"stream\",\"name\":\"users_addresses\",\"open\":false,\"details\":{\"purpose\":\"Stores addresses owned by users\"}}]' send"
su -l $username -c  "multichain-cli "$chainname" createrawsendfrom "$addr" '{}' '[{\"create\":\"stream\",\"name\":\"users_session\",\"open\":false,\"details\":{\"purpose\":\"Stores session history for users\"}}]' send"

su -l $username -c  "multichain-cli "$chainname" createrawsendfrom "$addr" '{}' '[{\"create\":\"stream\",\"name\":\"vault\",\"open\":false,\"details\":{\"purpose\":\"Stores documents uploaded by users\"}}]' send"

su -l $username -c  "multichain-cli "$chainname" createrawsendfrom "$addr" '{}' '[{\"create\":\"stream\",\"name\":\"contract_details\",\"open\":false,\"details\":{\"purpose\":\"Stores basic details of contracts\"}}]' send"
su -l $username -c  "multichain-cli "$chainname" createrawsendfrom "$addr" '{}' '[{\"create\":\"stream\",\"name\":\"contract_files\",\"open\":false,\"details\":{\"purpose\":\"Stores files related to contracts\"}}]' send"
su -l $username -c  "multichain-cli "$chainname" createrawsendfrom "$addr" '{}' '[{\"create\":\"stream\",\"name\":\"contract_signatures\",\"open\":false,\"details\":{\"purpose\":\"Stores signatures of contracts\"}}]' send"
su -l $username -c  "multichain-cli "$chainname" createrawsendfrom "$addr" '{}' '[{\"create\":\"stream\",\"name\":\"contracts_signed\",\"open\":false,\"details\":{\"purpose\":\"Stores the list of contracts signed by each user\"}}]' send"
su -l $username -c  "multichain-cli "$chainname" createrawsendfrom "$addr" '{}' '[{\"create\":\"stream\",\"name\":\"contract_invited_signees\",\"open\":false,\"details\":{\"purpose\":\"Stores the list of users invited to sign a contract\"}}]' send"


# SUBSCRIBE STREAMS
# --------- -------
su -l $username -c "multichain-cli "$chainname" subscribe proof_of_existence"

su -l $username -c  "multichain-cli "$chainname" subscribe users_credentials"
su -l $username -c  "multichain-cli "$chainname" subscribe users_details"
su -l $username -c  "multichain-cli "$chainname" subscribe users_addresses"
su -l $username -c  "multichain-cli "$chainname" subscribe users_session"

su -l $username -c  "multichain-cli "$chainname" subscribe vault"

su -l $username -c  "multichain-cli "$chainname" subscribe contract_details"
su -l $username -c  "multichain-cli "$chainname" subscribe contract_files"
su -l $username -c  "multichain-cli "$chainname" subscribe contract_signatures"
su -l $username -c  "multichain-cli "$chainname" subscribe contracts_signed"
su -l $username -c  "multichain-cli "$chainname" subscribe contract_invited_signees"



echo ''
echo ''
echo '----------------------------------------'
echo ''
echo ''
echo ''
echo ''

echo -e '----------------------------------------'
echo -e 'BLOCKCHAIN SUCCESSFULLY SET UP WITH YourCoin!'
echo -e '----------------------------------------'

echo -e 'Please install services for your blockchain now..'
sudo cd scripts
sudo ./app-setup-script.sh