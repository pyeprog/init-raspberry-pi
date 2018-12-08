# init-raspberry-pi
initial script for my raspberry pi B.

Here are the steps you need from the very beginning (without a screen, thus the headless installation):
1. Download [debian](https://www.raspberrypi.org/downloads/raspbian/) from here. The full version is recommanded.
Notice that NOOB has closed ssh accessibility by default, so it's impossible to connect to your raspi without a screen from NOOB.

2. Burn the downloaded .iso file into a usb stick.

3. Just add an empty file named `ssh` to your usb stick. This will open the ssh server by default.

4. Find a ethernet cable and connect your raspi to your wifi-router. 

5. Find the raspi's ip. My way is entering the dashboard of my wifi-router (enter 192.168.0.1 in browser) and check the ip address for my raspi.

6. `ssh pi@xxx.xxx.xxx.xxx`, in which xxx for ip number, or it's fine to use `ssh pi@raspberrypi.local` in most cases.

7. Boooyaa! You are in the raspberry's bash. Congrats!

8. `sudo raspi-config` to config the wifi connection. You can also open your i2c and spi interface here. After done, `sudo reboot` to reboot your board. 
And if your setting is correct, you can remove the ethernet cable and let it using wifi instead.

9. Now let's config the board. 
If you're in China, then clone this repo and run `sh init.sh`, it will:
  - change your apt source.list to Chinese source(tsinghua university provided.
  - download vim and git, and config git. **Please change the user.email in script**
  - add some alias to .bashrc
  - update and upgrade softwares using apt.
  - config raspi to run my XPT2046(480x320) touch screen according to [this](https://www.raspberrypi.org/forums/viewtopic.php?t=178443)
  

