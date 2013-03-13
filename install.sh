#!/bin/bash

account=`whoami`
if [ $account != "root" ]; then
    echo "Error : please use \"root\" account."
    exit 1
fi

user="svnserve"
svnroot="/var/svn"
fstype="fsfs"
#fstype="bdb"

echo "Set user to \"$user\""
echo "Set svnroot to \"$svnroot\""
echo "Set fstype to \"$fstype\""
if [ -d "$svnroot" ]; then
  echo "Error : folder \"$svnroot\" exists, change \"svnroot\" to another one."
  exit 1;
elif [ -f "$svnroot" ]; then
  echo "Error : file \"$svnroot\" exists, change \"svnroot\" to another one."
  exit 1;
else
  mkdir -p "$svnroot"
fi

sudo apt-get update
sudo apt-get -y install subversion
if [ ! -w "/usr/bin/svnserve" ]; then
  echo "Error : install failed, cannot find /usr/bin/svnserve"
  exit 1
fi
if [ ! -w "/usr/bin/svnadmin" ]; then
  echo "Error : install failed, cannot find /usr/bin/svnadmin"
  exit 1
fi
sudo adduser --system --home /nonexistent --shell /bin/bash --no-create-home --disabled-password --disabled-login $user

if [ ! -d "/etc/svnserve" ]; then
  mkdir -p "/etc/svnserve"
fi
sudo cp ./etc/svnserve/* /etc/svnserve/
sudo chown -R $user:nogroup /etc/svnserve/*
sudo cp ./etc/init.d/svnserve /etc/init.d/svnserve
sudo chown -R root:root /etc/init.d/svnserve
sudo chmod 700 /etc/init.d/svnserve
sudo ln -s /etc/init.d/svnserve /etc/rc0.d/K07svnserve
sudo ln -s /etc/init.d/svnserve /etc/rc1.d/K07svnserve
sudo ln -s /etc/init.d/svnserve /etc/rc2.d/S93svnserve
sudo ln -s /etc/init.d/svnserve /etc/rc3.d/S93svnserve
sudo ln -s /etc/init.d/svnserve /etc/rc4.d/S93svnserve
sudo ln -s /etc/init.d/svnserve /etc/rc5.d/S93svnserve
sudo ln -s /etc/init.d/svnserve /etc/rc6.d/K07svnserve

sudo chown -R $user:nogroup "$svnroot"
sudo -u $user svnadmin create --fs-type $fstype "$svnroot"

sudo service svnserve start
