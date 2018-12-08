#! /bin/bash

echo 'This is a initializing script'
echo 'Install and config vim'
sudo apt install vim git -y
git clone https://github.com/pyeprog/backup_rc.git
cd backup_rc/vim
sh vimConfInstall.sh
cd ../../
rm -rf backup_rc

# add alias
if [ -f $HOME/.bashrc ]; then
    cat ./alias >> $HOME/.bashrc
else
    mv ./alias $HOME/.bashrc
fi

# change apt source list to tsinghua's source
echo 'Chaning apt source.list'
sudo mv /etc/apt/source.list /etc/apt/source.list.bak
echo 'deb http://mirrors.tuna.tsinghua.edu.cn/raspbian/raspbian/ stretch main non-free contrib\
    deb-src http://mirrors.tuna.tsinghua.edu.cn/raspbian/raspbian/ stretch main non-free contrib' > ./source.list
sudo mv ./source.list /etc/apt/

echo 'Update apt and software'
sudo apt update -y
sudo apt upgrade -y
sudo rpi-update

# config touchable screen
if [ -f /boot/config.txt ]; then
    sudo echo 'dtoverlay=piscreen,speed=16000000,rotate=90\ngive Ctrl+X then save and exit.' >> /boot/config.txt
else
    sudo echo 'dtoverlay=piscreen,speed=16000000,rotate=90\ngive Ctrl+X then save and exit.' > /boot/config.txt
fi

sudo apt install fbi -y
sudo sed -i 's/fb0/fb1/g'

if [ ! -f /etc/xdg/lxsession/LXDE/touchscreen.sh ]; then
    sudo touch /etc/xdg/lxsession/LXDE/touchscreen.sh
fi
sudo echo "DISPLAY=:0 xinput --set-prop 'ADS7846 Touchscreen' 'Evdev Axes Swap' 0\
    DISPLAY=:0 xinput --set-prop 'ADS7846 Touchscreen' 'Evdev Axis Inversion' 1 0" >> /etc/xdg/lxsession/LXDE/touchscreen.sh
sudo chmod +x /etc/xdg/lxsession/LXDE/touchscreen.sh

if [ -f sudo nano /etc/xdg/lxsession/LXDE/autostart ]; then
    sudo sed -i /@xscreensaver -no-splash/i \
        '@lxterminal --command "/etc/xdg/lxsession/LXDE/touchscreen.sh"' /etc/xdg/lxsession/LXDE/autostart
else
    echo '@lxterminal --command "/etc/xdg/lxsession/LXDE/touchscreen.sh"' > /etc/xdg/lxsession/LXDE/autostart
fi

