FROM ubuntu:xenial
MAINTAINER Seyyed Shah <syd.shah@gmail.com>


ADD ARDrone_SDK_2_0_1.zip patches/ardrone1404.patch patches/ardrone1604.patch patches/OSXSegFault.patch /root/

RUN echo "Europe/London" > /etc/timezone && \
	dpkg-reconfigure -f noninteractive tzdata && \
	locale-gen en_GB.UTF-8 && \
	echo 'LANG="en_GB.UTF-8"'>/etc/default/locale && \
	dpkg-reconfigure --frontend=noninteractive locales && \
	update-locale LANG=en_GB.UTF-8 &&\
	export DEBIAN_FRONTEND=noninteractive && \
	if [ ! `grep "precise" /etc/lsb-release` ]; then dpkg --add-architecture i386; fi  && \
	apt-get -qq update && \
	apt-get -qq install -y unzip patch libncurses5-dev libncursesw5-dev libgtk2.0-dev libxml2-dev libudev-dev libiw-dev libsdl1.2-dev lib32z1 build-essential daemontools net-tools nano gcc-multilib && \ 
	export DEBIAN_FRONTEND=teletype 


RUN	ls "/files/ARDrone_SDK_2_0_1" || unzip -d /files/ /root/ARDrone_SDK_2_0_1.zip && \
   	cd /files/ && \ 
    	patch -p2  < /root/ardrone1404.patch && \
    	patch -p2  < /root/ardrone1604.patch && \
	rm -rf /root/ARDrone_SDK_2_0_1.zip /files/__MACOSX /files/.DSStore && \
	find . -name '.DS_Store' -type f -delete && \
	rm -rf /var/lib/apt/lists/* && \
	cd /files/ARDrone_SDK_2_0_1/Examples/Linux && \
	make
