#!/bin/bash

hostname=gateway # To make it easier for you, only change the hostname here and no need to touch other lines ;)

# Change the hostname of your VM
sudo hostnamectl set-hostname $hostname

# Change permanently the hostname of your VM
sudo rm -rf /etc/hosts
sudo cp ./hosts /etc/hosts

# Setup Gateway, to be the door of your Intern Network
sudo rm -rf /etc/network/interfaces
sudo cp ./interfaces /etc/network/interfaces

# Change the nameserver to reach internet
sudo rm -rf /etc/resolv.conf
sudo cp ./resolv.conf /etc/resolv.conf

# Restart the network of your VM to update it
sudo service networking restart

# Creation of the text that will be displayed every time someone will try to connect in ssh to your VM
sudo rm -rf /etc/issue.net
sudo cp ./issue.net /etc/issue.net

# Enabled the message to be displayed
sudo rm -rf /etc/sshd_config
sudo cp ./sshd_config /etc/sshd_config
sudo cp ./sshd_config /etc/ssh/sshd_config

# Update the ssh server
sudo service ssh reload

# Setup your VMs to able the FORWARDING
sudo rm -rf /etc/sysctl.conf
sudo cp ./sysctl.conf /etc/sysctl.conf

# Rules to be able to access internet on the other VMs of your Intern Network, by your Gateway Bridge Network
sudo iptables -A FORWARD -i ens33 -j ACCEPT
sudo iptables -A FORWARD -o ens33 -j ACCEPT
sudo iptables -t nat -A POSTROUTING ! -d 192.168.0.0/16 -o ens33 -j MASQUERADE

# Install the package too make your iptables permanent
sudo apt update
sudo apt install iptables-persistent