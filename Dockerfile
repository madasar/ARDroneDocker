FROM ubuntu:xenial
MAINTAINER Seyyed Shah <syd.shah@gmail.com>

ADD ARDrone_SDK_2_0_1.zip patches/ardrone1404.patch patches/ardrone1604.patch patches/debug.patch patches/OSXSegFault.patch /root/

RUN export DEBIAN_FRONTEND=noninteractive && \
    sed 's/main$/main universe/' -i /etc/apt/sources.list && \
    apt-get update && apt-get install -y software-properties-common && \
    add-apt-repository ppa:webupd8team/java -y && \
    apt-get update && \
    echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections && \
    apt-get install -y libgtk2.0-0 libcanberra-gtk-module oracle-java8-installer libxext-dev libxrender-dev libxtst-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/*

RUN wget http://mirror.switch.ch/eclipse/technology/epp/downloads/release/neon/3/eclipse-cpp-neon-3-linux-gtk-x86_64.tar.gz -O /tmp/eclipse.tar.gz -q && \
    echo 'Installing eclipse' && \
    tar -xf /tmp/eclipse.tar.gz -C /root/ && \
    rm /tmp/eclipse.tar.gz && \
cd /root/eclipse/plugins/org.eclipse.cdt.debug.application_*/scripts && \
/bin/sh ./install.sh

RUN echo "Europe/London" > /etc/timezone && \
	dpkg-reconfigure -f noninteractive tzdata && \
	locale-gen en_GB.UTF-8 && \
	echo 'LANG="en_GB.UTF-8"'>/etc/default/locale && \
	dpkg-reconfigure --frontend=noninteractive locales && \
	update-locale LANG=en_GB.UTF-8 &&\
	if [ ! `grep "precise" /etc/lsb-release` ]; then dpkg --add-architecture i386; fi  && \
	apt-get -qq update && \
	apt-get -qq install -y unzip patch libncurses5-dev libncursesw5-dev libgtk2.0-dev libxml2-dev libudev-dev libiw-dev libsdl1.2-dev lib32z1 build-essential daemontools net-tools nano gcc-multilib && \ 
	export DEBIAN_FRONTEND=teletype

RUN 	ls "/files/ARDrone_SDK_2_0_1" || unzip -d /files/ /root/ARDrone_SDK_2_0_1.zip && \
   	cd /files/ && \
    	patch -p2  < /root/ardrone1404.patch && \
    	patch -p2  < /root/ardrone1604.patch && \
	rm -rf /root/ARDrone_SDK_2_0_1.zip /files/__MACOSX /files/.DSStore && \
	find . -name '.DS_Store' -type f -delete && \
	rm -rf /var/lib/apt/lists/* && \
	cd /files/ARDrone_SDK_2_0_1/Examples/Linux && \
	make

RUN cd /files/ && \
	patch -p2 < /root/debug.patch&& \
	cd /files/ARDrone_SDK_2_0_1/Examples/Linux && \
	make

