# linux-scripts
Scripts for Linux VM/VPS/Metal SETUP

## How to Use
on Ubuntu, switch to root:
```bash
sudo su -
```

Run pre-installs of apps & configs, create user netadmin
```bash
bash <(curl -Ls https://raw.githubusercontent.com/FinchTechSoCal/ft-linux-scripts/refs/heads/main/ubuntu-setup.sh)
```

Give netadmin a password:
```bash
passwd netadmin
```

### Rename ubuntu user to new user
Logout & login as a different user (netadmin), switch to root
```bash
sudo su -
```
then
```bash
OLDUSER=ubuntu
NEWUSER=<newuser>
usermod -l $NEWUSER $OLDUSER
groupmod -n $NEWUSER $OLDUSER
usermod -d /home/$NEWUSER -m $NEWUSER
```