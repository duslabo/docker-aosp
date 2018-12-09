
# This generates a docker image used for building aosp

FROM ubuntu:16.04

LABEL maintainer="Prasant Jalan <prasant.jalan@gmail.com>"

RUN apt-get update

RUN apt-get install --quiet -y \
	apt-get install openjdk-8-jdk

RUN apt-get install --quiet -y \
	git-core gnupg flex bison gperf build-essential zip curl \
	zlib1g-dev gcc-multilib g++-multilib libc6-dev-i386 \
	lib32ncurses5-dev x11proto-core-dev libx11-dev lib32z-dev \
	libgl1-mesa-dev libxml2-utils xsltproc unzip

RUN apt-get install --quiet -y \
	vim \
	u-boot-tools

RUN id build 2>/dev/null || useradd --uid 1000 --create-home build
RUN echo "build ALL=(ALL) NOPASSWD: ALL" | tee -a /etc/sudoers

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
