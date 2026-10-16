#
# from ubuntu 20.04
#
FROM ubuntu:20.04

SHELL ["/bin/bash", "-c"]

#
# Add apt sources
#
RUN cp -a /etc/apt/sources.list /etc/apt/sources.list.bak \
&& sed -i 's@//.*archive.ubuntu.com@//mirrors.ustc.edu.cn@g' /etc/apt/sources.list

#
# install pack
#
RUN export DEBIAN_FRONTEND=noninteractive \
&& apt-get update \
&& apt-get upgrade -y \
&& apt-get install -y --no-install-recommends \
wget curl rsync ca-certificates bc bison byobu cmake cpio debootstrap \
device-tree-compiler dosfstools dpkg-dev exfat-utils fakeroot flex gcc kmod kpartx \
language-pack-en language-pack-zh-hans git libssl-dev libxml2 libxml2-dev qemu-user \
qemu-user-static rsync sudo u-boot-tools util-linux uuid uuid-dev lrzsz openssh-server \
vim nano python3-dev python3-pip gdb g++ build-essential p7zip-full bsdmainutils \
&& apt-get autoclean

RUN python3 -m pip install --upgrade pip -i https://pypi.tuna.tsinghua.edu.cn/simple \
&& python3 -m pip install setuptools --upgrade -i https://pypi.tuna.tsinghua.edu.cn/simple \
&& python3 -m pip install setuptools_rust --upgrade -i https://pypi.tuna.tsinghua.edu.cn/simple \
&& python3 -m pip install dfss --upgrade -i https://pypi.tuna.tsinghua.edu.cn/simple

#
# set work dir
#
WORKDIR /workspace
