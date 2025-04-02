#!/bin/bash
######################################################
#### WARNING PIPING TO BASH IS STUPID: DO NOT USE THIS
######################################################
# cheat & run this as sudo: bash <(curl -Ls https://raw.githubusercontent.com/ALFinternet/linux-scripts/master/ubuntu-install.sh)

# modified from: jcppkkk/prepare-ubuntu-template.sh
# TESTED ON UBUNTU 18.04 LTS

# SETUP & RUN
# curl -sL https://raw.githubusercontent.com/jimangel/ubuntu-18.04-scripts/master/prepare-ubuntu-18.04-template.sh | sudo -E bash -

# forked from https://github.com/jimangel/ubuntu-18.04-scripts/blob/master/prepare-ubuntu-18.04-template.sh
# - https://jimangel.io/post/create-a-vm-template-ubuntu-18.04/

if [ `id -u` -ne 0 ]; then
	echo Need sudo
	exit 1
fi

set -v

#update apt-cache
apt update -y
apt upgrade -y

#install packages
#apt install -y open-vm-tools # for VMware Only
apt install -y qemu-guest-agent
apt install -y apt-transport-https ca-certificates curl wget git gnupg-agent software-properties-common
apt install -y haveged ntp nfs-common net-tools cifs-utils htop parted tmux p7zip-full neofetch ubuntu-drivers-common


#set timezone
timedatectl set-timezone America/Los_Angeles

# add netadmin user,, use sudo passwd netadmin to set password
useradd -m finchtech -G sudo
usermod --shell /bin/bash finchtech
useradd -m netadmin -G sudo
usermod --shell /bin/bash netadmin

#############################################
# install docker because we always use it
for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do sudo apt-get remove $pkg; done

sudo install -m 0755 -d /etc/apt/keyrings

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg --yes
sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

apt update -y
apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin 

sudo groupadd docker
sudo usermod -aG docker root
sudo usermod -aG docker finchtech
sudo usermod -aG docker netadmin

# create my bridge network
docker network create --driver=bridge --subnet=10.42.0.0/24 --gateway=10.42.0.1 dbr0

# end DOCKER
#############################################


# disable MOTD & login spam
sed -i 's/ENABLED=1/ENABLED=0/g' /etc/default/motd-news
chmod -x /etc/update-motd.d/10-help-text

#sudo curl -Ls https://raw.githubusercontent.com/ALFinternet/linux-scripts/master/00-installer-config.yaml -o /etc/netplan/00-installer-config.yaml

# run anything on login https://gist.github.com/linuswillner/f8c15385e8a88017a70bdc3f18a688a2
#cat << 'EOL' | sudo tee /etc/profile.d/motd.sh
##!/bin/bash
#printf "\n"
#neofetch
#
#EOL
#chmod +x /etc/profile.d/motd.sh
