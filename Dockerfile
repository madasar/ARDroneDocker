FROM ubuntu:trusty
MAINTAINER Seyyed Shah <syd.shah@gmail.com>

VOLUME /files

# Configure timezone and locale, en_GB.UTF-8 required by ARDroneLib 
RUN echo "Europe/London" > /etc/timezone && \
    dpkg-reconfigure -f noninteractive tzdata && \
    locale-gen en_GB.UTF-8 && \
    echo 'LANG="en_GB.UTF-8"'>/etc/default/locale && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_GB.UTF-8

ADD ARDrone_SDK_2_0_1.zip /root/

ADD ardrone1404.patch /

RUN export DEBIAN_FRONTEND=noninteractive && \
	dpkg --add-architecture i386 && \
	apt-get -qq update && \
	apt-get -qq install -y unzip patch build-essential && \
	apt-get -qq install -y unzip patch libncurses5-dev libncursesw5-dev libgtk2.0-dev libxml2-dev libudev-dev libiw-dev libsdl1.2-dev lib32z1 build-essential daemontools net-tools nano gcc-multilib && \ 
	export DEBIAN_FRONTEND=teletype && \
	unzip -d /root/ /root/ARDrone_SDK_2_0_1.zip && \
    cd / && \ 
    patch -p1  < ardrone1404.patch && \
	cd /root/ARDrone_SDK_2_0_1/Examples/Linux && \
	make
