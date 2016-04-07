#!/usr/bin/bash -x

cd /tmp

# dependencies for cower and pacaur
pacman -S yajl expac git perl perl-error --noconfirm
export PATH=$PATH:/usr/bin/core_perl

sudo -u vagrant curl https://aur.archlinux.org/cgit/aur.git/snapshot/cower.tar.gz -o /tmp/cower.tar.gz
sudo -u vagrant curl https://aur.archlinux.org/cgit/aur.git/snapshot/pacaur.tar.gz -o /tmp/pacaur.tar.gz

# for installing cower/pacaur
count=0
while [ $count -lt 5 ]; do
    sudo -u vagrant /usr/bin/gpg --recv-key 1EB2638FF56C0C53
    sleep 3
    sudo -u vagrant /usr/bin/gpg --list-key 1EB2638FF56C0C53 2>/dev/null
    keyFound=$?
    if [ $keyFound -eq 0 ]; then
        count=5
    else
        let count=count+1
    fi
done
if [ ! $keyFound ]; then
    echo "key 1EB2638FF56C0C53 not found -- exiting"
    exit 1
fi

# install cower/pacaur
sudo -u vagrant /usr/bin/tar -zxvf cower.tar.gz
cd cower
/usr/bin/sudo -u vagrant /usr/bin/makepkg -sc
/usr/bin/pacman -U cower*.xz --noconfirm

cd /tmp
sudo -u vagrant /usr/bin/tar -zxf pacaur.tar.gz
cd pacaur
/usr/bin/sudo -u vagrant /usr/bin/makepkg -sc
/usr/bin/pacman -U pacaur*.xz --noconfirm
cd /tmp

# install missing packages, xfce environment, etc
chmod +x /tmp/pkgdiff.sh
/tmp/pkgdiff.sh /tmp/p.txt
/usr/bin/cat to_install | sudo -u vagrant /usr/bin/xargs /usr/bin/pacaur -S --noconfirm --noedit

# enable network manager and graphical login manager
systemctl enable NetworkManager
systemctl enable lightdm

# Anypoint Studio
sudo -u vagrant mkdir -p /home/vagrant/Tools
sudo -u vagrant /usr/bin/tar -zxf /home/vagrant/AnypointStudio.tar.gz -C /home/vagrant/Tools

# Copy desktop file
sudo -u vagrant mkdir -p /home/vagrant/.local/share/applications
sudo -u vagrant cp /tmp/AnypointStudio.desktop /home/vagrant/.local/share/applications
sudo -u vagrant chmod +x /home/vagrant/.local/share/applications/AnypointStudio.desktop

cd
