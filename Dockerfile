#
# 1. 设置基础镜像
#
FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

SHELL ["/bin/bash", "-c"]

#
# 2. 换国内源 + 安装编译依赖
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
# 3. 安装 python 依赖
#
RUN python3 -m pip install --upgrade pip setuptools setuptools_rust dfss -i https://pypi.tuna.tsinghua.edu.cn/simple

#
# 4. 安装 bsp 依赖
#
RUN mkdir /env && pushd /env/ \
&& git clone https://github.com/sophgo/bootloader-arm64.git \
&& git clone https://github.com/sophgo/linux-arm64.git \
&& git clone https://github.com/sophgo/libsophon.git \
&& python3 -m dfss --url=open@sophgo.com:/sophon-bsp/BSP_SDK.zip \
&& 7z x BSP_SDK.zip \
&& mv 'BSP SDK'/* ./ \
&& rm -rf 'BSP SDK' \
&& rm -rf BSP_SDK.zip \
&& rm -rf memory_layout_modification_tool \
&& tar -xaf gcc-linaro-6.3.1-2017.05-x86_64_aarch64-linux-gnu.tar.xz \
&& mkdir qt_fl2000 && pushd qt_fl2000 \
&& python3 -m dfss --dflag=sophgo-bsp-qt5-fl2000fb-toolchain \
&& tar -xaf *.tar.xz \
&& popd \
&& mkdir qt_ms9132 && pushd qt_ms9132 \
&& python3 -m dfss --dflag=sophgo-bsp-qt5-ms9132-toolchain \
&& tar -xaf *.tar.xz \
&& popd \
&& popd

#
# 5. 设置 PATH 环境变量
#
ENV PATH "$PATH:/env/gcc-linaro-6.3.1-2017.05-x86_64_aarch64-linux-gnu/bin"

#
# 6. 设置语言环境
#
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

#
# 7. 设置工作目录
#
WORKDIR /workspace
