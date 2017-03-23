FROM ubuntu:precise
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

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y unzip libncurses5-dev libncursesw5-dev libgtk2.0-dev libxml2-dev libudev-dev libiw-dev libsdl1.2-dev ia32-libs build-essential daemontools net-tools nano && \
	unzip -d /root/ /root/ARDrone_SDK_2_0_1.zip && \
	cd /root/ARDrone_SDK_2_0_1/Examples/Linux && \
	make

ENV DEBIAN_FRONTEND teletype

