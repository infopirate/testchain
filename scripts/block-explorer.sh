#!/bin/bash
###
## INSTALLING & CONFIGURING MULTICHAIN EXPLORER
###

cd /home/$username
git clone https://github.com/MultiChain/multichain-explorer.git
cd multichain-explorer
sudo python setup.py install

sudo bash -c 'cp /home/'$username'/multichain-explorer/chain1.example.conf /home/'$username'/multichain-explorer/'$chainname'.conf'

sudo sed -ie 's/MultiChain chain1/'$explorerDisplayName'/g' /home/$username/multichain-explorer/$chainname.conf
sudo sed -ie 's/2750/'$explorerport'/g' /home/$username/multichain-explorer/$chainname.conf
sudo sed -ie 's/chain1/'$chainname'/g' /home/$username/multichain-explorer/$chainname.conf
sudo sed -ie 's/host localhost.*\#/host  localhost 	#/g' /home/$username/multichain-explorer/$chainname.conf
sudo sed -ie 's/host localhost/host 0.0.0.0/g' /home/$username/multichain-explorer/$chainname.conf
sudo sed -ie 's/chain1.explorer.sqlite/'$chainname'.explorer.sqlite/g' /home/$username/multichain-explorer/$chainname.conf

su -l $username -c "python -m Mce.abe --config /home/"$username"/multichain-explorer/"$chainname".conf --commit-bytes 100000 --no-serve"
sleep 5
su -l $username -c "echo -ne '\n' | nohup python -m Mce.abe --config /home/"$username"/multichain-explorer/"$chainname".conf > /dev/null 2>/dev/null &"
