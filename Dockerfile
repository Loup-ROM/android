FROM ubuntu:18.04
MAINTAINER bitrvmpd
ARG WORKSPACE=/usr/src/loup
# if we want to install via apt
RUN apt-get update --fix-missing
 
# Kernel build dependencies
RUN apt-get install -y \
	g++ \
	zip \
	ccache \
	gcc \
	make \
	libfl-dev \
	libncurses5-dev \
	flex \
	bc \
	kmod

# Android rom build dependencies
RUN apt-get install -y \
	build-essential \
	g++-multilib \
	gcc-multilib \
	gperf \
	imagemagick \
	lib32ncurses5-dev \
	lib32readline6-dev \
	lib32z1-dev \
	liblz4-tool \
	libsdl1.2-dev \
	libwxgtk3.0-dev \
	libxml2 \
	libxml2-utils \
	lzop \
	pngcrush \
	schedtool \
	squashfs-tools \
	xsltproc \
	zlib1g-dev \
	rsync \
	autoconf \
	automake \
	perl \
	curl \
	git \
	jq \
	sshpass \
	python-minimal

# Fix for libesd0-dev missing
RUN echo "deb http://archive.ubuntu.com/ubuntu/ xenial main universe" > /etc/apt/sources.list.d/xenial.list
RUN echo "deb-src http://us.archive.ubuntu.com/ubuntu/ xenial main universe" >> /etc/apt/sources.list.d/xenial.list
RUN apt-get update --fix-missing
RUN apt-get install -y libesd0-dev

RUN mkdir -p $WORKSPACE
RUN mkdir $WORKSPACE/android-dependencies && git clone https://github.com/bitrvmpd/jenkins-android-build.git --depth=1 $WORKSPACE/android-dependencies/jenkins-android-build
RUN mv $WORKSPACE/android-dependencies/jenkins-android-build/libfl.so.2.0.0 /usr/lib/.
RUN ln -s /usr/lib/libfl.so.2.0.0 /usr/lib/libfl.so
RUN rm -f /usr/lib/libfl.so.2 
RUN ln -s /usr/lib/libfl.so.2.0.0 /usr/lib/libfl.so.2
RUN mkdir -p /usr/lib/x86_64-linux-gnu
RUN rm -f /usr/lib/x86_64-linux-gnu/libfl.so
RUN ln -s /usr/lib/libfl.so.2.0.0 /usr/lib/x86_64-linux-gnu/libfl.so
RUN rm -f /usr/lib/x86_64-linux-gnu/libfl.so.2
RUN ln -s /usr/lib/libfl.so.2.0.0 /usr/lib/x86_64-linux-gnu/libfl.so.2
# Dirty fix for libmpfr.so.4 missing
RUN ln -s /usr/lib/x86_64-linux-gnu/libmpfr.so.6 /usr/lib/x86_64-linux-gnu/libmpfr.so.4

RUN git config --global color.ui true
RUN git config --global user.email "ci@drone.io"
RUN git config --global user.name "loup"

# Openjdk-8-jdk
RUN apt-get install -y openjdk-8-jdk

# Install repo from google
RUN curl https://storage.googleapis.com/git-repo-downloads/repo > /usr/bin/repo && chmod a+x /usr/bin/repo
