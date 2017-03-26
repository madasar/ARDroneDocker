## Synopsis

Ubuntu-based docker container to compile the Parrot AR Drone SDK, created to simplify and automate the compilation. The last update to the v2 SDK was in ~2013, targeting Ubuntu 12.04 i386. Parrot has released the v3 SDK for newer drones, without support the AR 1.0 or 2.0 drones.

## Ubuntu Version

The container is tested with Docker version 1.26 on Ubuntu 16.04. The container patches the SDK before compiling ([via](http://stackoverflow.com/questions/35052653/compiling-ar-drone-sdk-fails-with-dso-missing-from-command-line) and [via](http://jderobot.org/Varribas-tfm/ARDrone:starting_up#Building_Examples)). The container works with `ubuntu:precise`, `ubuntu:trusty` and `ubuntu:xenial` (default).

The SDK is included as a blob in this repo (~65MB) and can also be freely downloaded [from here](http://developer.parrot.com/docs/SDK2/ARDrone_SDK_2_0_1.zip). The SDK code is included here for convenience and retains the original licence(s).

The docker images download ~150MB, take 1GB of space, and automate most the 5 minute build process.

## Usage 

[Get docker](https://www.docker.com/community-edition#/download).

Clone the repo:

`git clone https://github.com/seyyedshah/ARDroneDocker.git`

To build the image with the `--ulimit` option set to speed up build:

`docker build  --ulimit nofile=12800:25600 . -t ardrone2sdk`

(wait ~5 minutes)

To run the image:

`docker run -it ardrone2sdk bash --login -i`

To run the SDK example code, the built SDK example code can be found the following folder:

`cd /root/ARDrone_SDK_2_0_1/Examples/Linux/Build/Release`

`./linux_sdk_demo`

`./ardrone_navigation`

`./linux_video_demo`

`./sym_ardrone_testing_tool`

You can the start writing your code and building as per the SDK instructions and examples.  Changes are saved to the `/files` folder by default.

## Docker Options

### ulimits

To build the image with the `--ulimit` option set to speed up build in trusty:

`docker build  --ulimit nofile=12800:25600 . -t ardrone2sdk:trusty`

### Save data from the container

To run the image with the local `files` folder synchronised with `/files` on the container add ``-v `pwd`/files:/root/files``. Any files put in the `/files` on the container will be saved on file system of host machine.

``docker run -v `pwd`/files:/files -it ardrone2sdk bash --login -i``

### Running graphical docker applications 

Several of the SDK demos create a video preview, you may have an error `cannot open display :0`. To run the image so graphical applications can be shown in the host:

`docker run -e DISPLAY=:0 -v /tmp/.X11-unix:/tmp/.X11-unix -it ardrone2sdk bash --login -i`

[via](http://fabiorehm.com/blog/2014/09/11/running-gui-apps-with-docker/) you may need to `xhost +` on a Linux host [see](http://stackoverflow.com/questions/28392949/running-chromium-inside-docker-gtk-cannot-open-display-0). 

### Running graphical docker applications on a Mac

In OSX, you will need to install xQuartz, and socat (`brew install socat`), first run:

`socat TCP-LISTEN:6000,reuseaddr,fork UNIX-CLIENT:\"$DISPLAY\"`

Then, in a different terminal:

`ip=$(ifconfig en0 | grep inet | awk '$1=="inet" {print $2}')` (gets your IP address, en0 can vary `ip=$(hostname)` may work better)

`open -a XQuartz` (set “Authenticate Connections” and “Allow Network Clients” under “Preferences” -> “Security”)

`xhost + $ip` (grants access to the XServer from the saved ip)

`run -v `pwd`/files:/files -e DISPLAY=$ip:0 -it ardrone2sdk bash --login -i``

These instructions need more testing and are based in on [this blog](http://kartoza.com/en/blog/how-to-run-a-linux-gui-application-on-osx-using-docker/) which seemed to work for me. Also [see](https://fredrikaverpil.github.io/2016/07/31/docker-for-mac-and-gui-applications/).

### Networking

The SDK communicates with the drone over wifi. To give the Docker container direct access to local networking, including the host's wifi connection:

`docker run --net=host -it ardrone2sdk bash --login -i`

N.B. There is a security risk with the `--net-host` approach, only run docker images and programs that you trust with this option. [see](https://github.com/fgg89/docker-ap/wiki/Container-access-to-wireless-network-interface).

## General Docker Commands:

Kill (stop) all containers:

`docker kill $(docker ps -a -q)`

Remove all containers:

`docker rm $(docker ps -a -q)`

Remove all images:

`docker rmi $(docker images -a -q)`

Remove all volumes:

`docker volume rm $(docker volume ls -q)`

Remove any dangling volumes:

`docker volume rm $(docker volume ls -qf dangling=true)`

On Linux the Docker container may lose internet connectivity, with no `docker0` in the output of `ip route` on the host. This is especially true if you use VPNs or other tunnelling that modifies the default routes. To remove and re add the `docker0` bridge on linux:

`service docker stop`

`ip link del docker0`

`nmcli connection delete docker0 #if you use network manager` 

`service docker start`
 