## Synopsis

Ubuntu-based docker containers to compile the Parrot v2 SDK. The original Drone was released in ~2010 for the AR 1.0 and 2.0 drones and the last update (~2012?) targets Ubuntu 12.04 i386. This docker container was created to simplify and automate the complitation on modern systems.

## Details

There are two versions:

* 12.04 LTS Precise Pangolin amd64 (FROM ubuntu:precise - EOL April 2017)
* 14.04 LTS Trusty Tahr amd64 (FROM ubuntu:trusty - EOL April 2019)

Both are tested with Docker version 1.26 on Ubuntu 16.04. The `trusty` version patches the SDK before compiling ([via](http://stackoverflow.com/questions/35052653/compiling-ar-drone-sdk-fails-with-dso-missing-from-command-line) and [via](http://jderobot.org/Varribas-tfm/ARDrone:starting_up#Building_Examples)), uses a slightly different set of packages, and takes longer to build due to a debconf issue. N.B. not tested on OSX/windows, requires access to the drone via wifi.

The v2 SDK is included as a blob in this repo (~65MB) and can also be freely downloaded [from here](http://developer.parrot.com/docs/SDK2/ARDrone_SDK_2_0_1.zip). The SDK code is included here for convenience and retains the original licence(s).

The alternative to using docker is to setup a Precise or Trusty virtual machine and use the Docker files as a guide to compile the sdk. The docker images take up around 900MB, and download ~150MB including this repository and automates most of the process. An Ubuntu VM image would take at least 10GB and require downloading at least a 1GB VM image and manaully compling the SDK.

## Usage 

[Get docker](https://www.docker.com/community-edition#/download).

Clone the repo:

`git clone https://github.com/seyyedshah/ARDroneDocker.git -b precise ARDroneDocker-precise` (for the ubuntu 12.04 version)

or

`git clone https://github.com/seyyedshah/ARDroneDocker.git -b trusty ARDroneDocker-trusty` (for the ubuntu 14.04 version)

`cd` to cloned folder and build the image:

`docker build . -t ardrone2sdk` (this takes a couple of minutes)

To run the image:

`docker run -it ardrone2sdk bash --login -i`

To run the image with all the options (explained below):

``docker run --net=host -e DISPLAY=:0 -v /tmp/.X11-unix:/tmp/.X11-unix -v `pwd`/files:/files -it ardrone2sdk bash --login -i``

The ready-built SDK example code can be found the following folder:

`cd /root/ARDrone_SDK_2_0_1/Examples/Linux/Build/Release`

`./linux_sdk_demo`

You can the start writing your code and building as per the SDK instructions and examples. Remember to transfer any code out of the container before exiting. Changes are not persistent by default.

## Docker Options

To run the image with the local `files` folder syncronised with `/files` on the container add ``-v `pwd`/files:/root/files``. Any files put in the `/files` on the container will be saved on file system of host machine.

``docker run -v `pwd`/files:/files -it ardrone2sdk bash --login -i``

To run the image so graphical applications can shown in the host:

`docker run -e DISPLAY=:0 -v /tmp/.X11-unix:/tmp/.X11-unix -it ardrone2sdk bash --login -i`

[via](http://fabiorehm.com/blog/2014/09/11/running-gui-apps-with-docker/) you may need to `xhost +` on a Linux host [see](http://stackoverflow.com/questions/28392949/running-chromium-inside-docker-gtk-cannot-open-display-0). On a mac, you will need to install xQuartz, [see](https://fredrikaverpil.github.io/2016/07/31/docker-for-mac-and-gui-applications/). 

To give the Docker container direct access to local networking, including the host's wifi connection:

`docker run --net=host -it ardrone2sdk bash --login -i`

N.B. There is a security risk with the `--net-host` approach, only run docker images and programs that you trust with this option. [see](https://github.com/fgg89/docker-ap/wiki/Container-access-to-wireless-network-interface). Not tested on OSX/windows.

## General Docker Commands:

Kill (stop) all running containers:

`docker kill $(docker ps -a -q)`

Remove all containers:

`docker rm $(docker ps -a -q)`

Remove all images:

`docker rmi $(docker images -a -q)`

Remove all volumes:

`docker volume rm $(docker volume ls -q)`

Remove any dangling volumes:

`docker volume rm $(docker volume ls -qf dangling=true)`

In rare cases, the Docker container may lose internet connectivity, (no `docker0` in the output of `ip route` on the host). To remove and re add the `docker0` bridge on linux:

`service docker stop`

`ip link del docker0`

`nmcli connection delete docker0 #if you use network manager` 

`service docker start`
 


