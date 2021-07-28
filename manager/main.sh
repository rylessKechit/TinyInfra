#!/bin/bash

hostname=manager # To make it easier for you, only change the hostname here and no need to touch other lines ;)

# Change the hostname of your VM
sudo hostnamectl set-hostname $hostname

# Change permanently the hostname of your VM
sudo rm -rf /etc/hosts
sudo cp ./hosts /etc/hosts

# Setup your VM's network to be able to connect to the Gateway
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

# Install the package to configure your DHCP
sudo apt update
sudo apt install isc-dhcp-server

# Configure your DHCP to work on your Intern Network
sudo rm -rf /etc/default/isc-dhcp-server
sudo cp ./isc-dhcp-server /etc/default/isc-dhcp-server

# Restart the network of your VM to update it
sudo systemctl restart networking

# Setup the DHCP of your VM to give static IP to clients
sudo rm -rf /etc/dhcp/dhcpd.conf
sudo cp ./dhcpd.conf /etc/dhcp/dhcpd.conf

# Restart the network of your VM to update it
sudo systemctl restart networking

# Install the package to configure your DNS
sudo apt install dnsmasq

# Configure your DNS to work on your Intern Network
sudo m -rf /etc/dnsmasq.conf
sudo cp ./dnsmasq.conf /etc/dnsmasq.conf

# Restart the DNS of your VM to update it
sudo /etc/init.d/dnsmasq restart