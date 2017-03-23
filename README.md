## Synopsis

This is a Docker container based on Ubuntu 12.04 Precise (FROM ubuntu:precise) that compiles the Parrot SDK v2. The original SDK was released in 2009 for the AR series of drones. This docker containter was created because as the SDK code no longer compiles in later linuxes.

The SDK is included as a blob in this repo (~65MB) and can also be freely downloaded [from here](http://developer.parrot.com/docs/SDK2/ARDrone_SDK_2_0_1.zip). The SDK code is included here for convenience and retains the original licence(s).

## Docker Build and Run Command

First clone this repo:

`git clone https://github.com/seyyedshah/ARDroneDocker.git`

`cd ARDroneDocker`

Build the image:

`docker build . -t ardrone2sdk`

To run the image with a shell:

`docker run -it ardrone2sdk bash --login -i`

The built SDK example code can be found in the `/root/ARDrone_SDK_2_0_1/Examples/Linux/Build/Releases` folder.

`cd /root/ARDrone_SDK_2_0_1/Examples/Linux/Build/Releases`

`./linux_sdk_demo`

You can the start writing your code and building as per the SDK instructions and examples. Remember to transfer any code out of the container before exiting. Changes are not persistent by default.

## More Advanced Docker Options

To run the image with the local `files` folder syncronised with `/files` on the container add ``-v `pwd`/files:/root/files``. Any files put in the `/files` on the container will be saved on file system of host machine.

``docker run -v `pwd`/files:/files -it ardrone2sdk bash --login -i``

To run the image so graphical applications can shown in the host:

`docker run -e DISPLAY=:0 -v /tmp/.X11-unix:/tmp/.X11-unix -it ardrone2sdk bash --login -i`

[via](http://fabiorehm.com/blog/2014/09/11/running-gui-apps-with-docker/) you may need to `xhost +` on a Linux host [see](http://stackoverflow.com/questions/28392949/running-chromium-inside-docker-gtk-cannot-open-display-0) and install xQuartz on a mac [see](https://fredrikaverpil.github.io/2016/07/31/docker-for-mac-and-gui-applications/). Not tested on OSX/windows.

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

In rare cases, the Docker container may lose internet connectivity, (no `docker0` in the output `ip route` on the host). To remove and re add the `docker0` bridge on linux:

`service docker stop`
`ip link del docker0`
`nmcli connection delete docker0 #if you use network manager` 
`service docker start`
 


