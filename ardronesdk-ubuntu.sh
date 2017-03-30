#!/bin/bash

#ardrone SDK build script works on ubuntu 16.04 14.04 12.04

echo "setting timzone and locale (as sudo)"
sudo -s -- "echo "Europe/London" > /etc/timezone && \
	dpkg-reconfigure -f noninteractive tzdata && \
	locale-gen en_GB.UTF-8 && \
	echo 'LANG="en_GB.UTF-8"'>/etc/default/locale && \
	dpkg-reconfigure --frontend=noninteractive locales && \
	update-locale LANG=en_GB.UTF-8"



if [ ! `grep "precise" /etc/lsb-release` ]; then 
echo "adding architecture (as sudo)"; sudo dpkg --add-architecture i386; fi



echo "installing packages (as sudo)"
sudo apt-get update 
sudo apt-get install -y unzip patch gdb libncurses5-dev libncursesw5-dev libgtk2.0-dev libxml2-dev libudev-dev libiw-dev libsdl1.2-dev lib32z1 build-essential daemontools net-tools nano gcc-multilib



echo "downloading SDK to $HOME/ArdroneSDK/"
mkdir -p $HOME/ArdroneSDK/
ls "$HOME/ArdroneSDK/ARDrone_SDK_2_0_1" || wget http://developer.parrot.com/docs/SDK2/ARDrone_SDK_2_0_1.zip -O $HOME/ArdroneSDK/ARDrone_SDK_2_0_1.zip



echo "extracting SDK"

ls "$HOME/ArdroneSDK/ARDrone_SDK_2_0_1" || unzip -d $HOME/ArdroneSDK/ $HOME/ArdroneSDK/ARDrone_SDK_2_0_1.zip
#cleanup:
rm -rf $HOME/ArdroneSDK/ARDrone_SDK_2_0_1.zip $HOME/ArdroneSDK/__MACOSX
find $HOME/ArdroneSDK/ -name '.DS_Store' -type f -delete



echo "patching SDK"
wget https://raw.githubusercontent.com/seyyedshah/ARDroneDocker/master/patches/ardrone1404.patch -O $HOME/ArdroneSDK/ardrone1404.patch
wget https://raw.githubusercontent.com/seyyedshah/ARDroneDocker/master/patches/ardrone1604.patch -O $HOME/ArdroneSDK/ardrone1604.patch
cd $HOME/ArdroneSDK/
patch -p2  < $HOME/ArdroneSDK/ardrone1604.patch
patch -p2  < $HOME/ArdroneSDK/ardrone1404.patch




echo "building SDK"
cd  $HOME/ArdroneSDK/ARDrone_SDK_2_0_1/Examples/Linux
make && echo "SDK Built $HOME/ArdroneSDK/ARDrone_SDK_2_0_1/Examples/Linux/Build/Release"



echo "building SDK (debug)"
wget https://raw.githubusercontent.com/seyyedshah/ARDroneDocker/experimental/patches/debug.patch -O $HOME/ArdroneSDK/debug.patch
cd $HOME/ArdroneSDK/
patch -p2  < $HOME/ArdroneSDK/debug.patch
cd  $HOME/ArdroneSDK/ARDrone_SDK_2_0_1/Examples/Linux
make && echo "debug SDK Built"



cd  $HOME/ArdroneSDK/ARDrone_SDK_2_0_1/Examples/Linux/Build/Release

