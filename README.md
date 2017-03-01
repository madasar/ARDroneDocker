##Synopsis

This is a Docker container for Ubuntu 12.04 Precise that compiles the example code from the Parrot SDK for the AR series of drones.

The SDK is included as a blob in this repo (~65MB) and can also be freely downloaded [from here:](http://developer.parrot.com/docs/SDK2/ARDrone_SDK_2_0_1.zip). The SDK code is included here for convenience and retains the original licence(s).

##Commands

First clone this repo:

`git clone https://github.com/seyyedshah/ARDroneDocker.git`

`cd ARDroneDocker`

Build the image:

`docker build . -t ardrone2sdk`

To run the image with a shell:

`docker run -it ardrone2sdk bash --login -i`

`cd` into `/root/ARDrone_SDK_2_0_1/Examples/Linux/` the built SDK example code can be found in the `Built` folder.

You can the start writing your code and building as per the SDK instructions and examples. Remember to transfer any code out of the container before exiting. Changes are not persistent by default.

##More Commands

To run the image with the local `files` folder available and synced with `/root/files` on the container add ``-v `pwd`/files:/root/files``

``docker run -v `pwd`/files:/root/files -it ardrone2sdk bash --login -i``

To run the image so graphical applications are shown in the host:

`docker run -e DISPLAY=:0 -v /tmp/.X11-unix:/tmp/.X11-unix -it ardrone2sdk bash --login -i`

([via:](http://fabiorehm.com/blog/2014/09/11/running-gui-apps-with-docker/) you may need to `xhost +` on the Linux host [via:](http://stackoverflow.com/questions/28392949/running-chromium-inside-docker-gtk-cannot-open-display-0))

##General Docker Commands:

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


