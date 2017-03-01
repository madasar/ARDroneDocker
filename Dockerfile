FROM ubuntu:precise
MAINTAINER Seyyed Shah <syd.shah@gmail.com>

ADD ARDrone_SDK_2_0_1.zip /root/

RUN apt-get update && apt-get install -y unzip libncurses5-dev libncursesw5-dev libgtk2.0-dev libxml2-dev libudev-dev libiw-dev libsdl1.2-dev ia32-libs build-essential daemontools net-tools

RUN unzip -d /root/ /root/ARDrone_SDK_2_0_1.zip

RUN cd /root/ARDrone_SDK_2_0_1/Examples/Linux && make

