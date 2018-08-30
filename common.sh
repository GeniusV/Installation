#!/bin/bash
# This is the common server init setup script. Tested on Debian 8.

# First add global common alias.
echo 'alias c="clear"' >> /etc/profile
echo 'alias l="ls -lAh"' >> /etc/profile
source /etc/profile


# Update apt-get
apt-get update

# Install Vim
apt-get install vim -y


