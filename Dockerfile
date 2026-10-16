#
# 1. 设置基础镜像
#
FROM ubuntu:20.04

#
# 2. 设置环境变量
#
ENV DEBIAN_FRONTEND=noninteractive

#
# 3. 设置全局指令
#
SHELL ["/bin/bash", "-c"]

#
# 4. 换国内源 + 安装编译依赖
#
RUN cp -a /etc/apt/sources.list /etc/apt/sources.list.bak \
&& sed -i 's@//.*archive.ubuntu.com@//mirrors.ustc.edu.cn@g' /etc/apt/sources.list \
&& apt-get update \
&& apt-get upgrade -y \
&& apt-get install -y --no-install-recommends \
wget curl rsync ca-certificates bc bison byobu cmake cpio debootstrap \
device-tree-compiler dosfstools dpkg-dev exfat-utils fakeroot flex gcc kmod kpartx \
language-pack-en language-pack-zh-hans git libssl-dev libxml2 libxml2-dev qemu-user \
qemu-user-static rsync sudo u-boot-tools util-linux uuid uuid-dev lrzsz openssh-server \
vim nano python3-dev python3-pip gdb g++ build-essential p7zip-full bsdmainutils \
&& rm -rf /var/lib/apt/lists/*

#
# 5. 设置工作目录
#
WORKDIR /env
