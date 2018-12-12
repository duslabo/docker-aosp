
# This generates a docker image used for building aosp

FROM ubuntu:14.04

LABEL maintainer="Prasant Jalan <prasant.jalan@gmail.com>"

RUN apt-get update

RUN apt-get install --quiet -y \
	openjdk-7-jdk

RUN apt-get install --quiet -y \
	git-core gnupg flex bison gperf libsdl1.2-dev \
	libesd0-dev libwxgtk2.8-dev squashfs-tools build-essential zip curl \
	libncurses5-dev zlib1g-dev pngcrush schedtool libxml2 libxml2-utils \
	xsltproc lzop libc6-dev schedtool g++-multilib lib32z1-dev \
	lib32ncurses5-dev lib32readline-gplv2-dev gcc-multilib libswitch-perl \
	libssl1.0.0 libssl-dev genisoimage

RUN apt-get install --quiet -y \
	vim \
	u-boot-tools \
	bc

RUN id build 2>/dev/null || useradd --uid 1000 --create-home build
RUN echo "build ALL=(ALL) NOPASSWD: ALL" | tee -a /etc/sudoers
RUN echo 'alias l="ls -allFh"' >> ~/.bashrc

RUN apt -y install locales && \
  dpkg-reconfigure locales && \
  locale-gen en_US.UTF-8 && \
  update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8

ENV LANG=en_US.UTF-8

# Clean up apt temp files
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Add repo utility
ADD https://commondatastorage.googleapis.com/git-repo-downloads/repo /usr/local/bin/
RUN chmod 755 /usr/local/bin/*

USER build
WORKDIR /home/build
CMD "/bin/bash"
