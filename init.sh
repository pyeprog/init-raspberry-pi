##! /bin/bash

echo 'This is a initializing script'
echo 'Install and config vim'
sudo apt install vim git -y
git clone https://github.com/pyeprog/backup_rc.git
git config --global user.email "pyeprog@foxmail.com"
git config --global user.name "pd"
git config --global credential.helper store
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
source $HOME/.bashrc

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
    sudo sed -i '$a\dtoverlay=piscreen,speed=16000000,rotate=90' /boot/config.txt
else
    echo 'dtoverlay=piscreen,speed=16000000,rotate=90' > ./config.txt
    sudo mv config.txt /boot
fi

sudo apt install fbi -y
sudo sed -i 's/fb0/fb1/g' /usr/share/X11/xorg.conf.d/99-fbturbo.conf

if [ ! -f /etc/xdg/lxsession/LXDE/touchscreen.sh ]; then
    sudo touch /etc/xdg/lxsession/LXDE/touchscreen.sh
fi
sudo mv /etc/xdg/lxsession/LXDE/touchscreen.sh ./
sudo chown $(whoami):$(whoami) touchscreen.sh
echo "DISPLAY=:0 xinput --set-prop 'ADS7846 Touchscreen' 'Evdev Axes Swap' 0\nDISPLAY=:0 xinput --set-prop 'ADS7846 Touchscreen' 'Evdev Axis Inversion' 1 0" >> touchscreen.sh
sudo mv touchscreen.sh /etc/xdg/lxsession/LXDE/
sudo chmod +x /etc/xdg/lxsession/LXDE/touchscreen.sh
sudo chown root:root /etc/xdg/lxsession/LXDE/touchscreen.sh

if [ -f /etc/xdg/lxsession/LXDE/autostart ]; then
    sudo sed -ie /'@xscreensaver \-no-splash'/i'@lxterminal --command "/etc/xdg/lxsession/LXDE/touchscreen.sh"' /etc/xdg/lxsession/LXDE/autostart
else
    echo '@lxterminal --command "/etc/xdg/lxsession/LXDE/touchscreen.sh"' > ./autostart
    sudo mv autostart /etc/xdg/lxsession/LXDE/
fi

