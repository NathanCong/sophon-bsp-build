# sophon-bsp-build

用于 Sophon 设备 SD 刷机包制作

## Scripts

### 服务启动

```bash
#
# 服务启动之前，执行 Dockerfile 构建
#
sudo bash scripts/start.sh

#
# 服务直接启动，忽略 Dockerfile 构建
#
sudo bash scripts/start.sh --no-build
```

### 服务停止

```bash
#
# 关闭服务，清理所有和服务相关的镜像
#
sudo bash scripts/close.sh

#
# 关闭服务，保留所有和服务相关的镜像
#
sudo bash scripts/close.sh --no-clean
```

### 服务重启

```bash
#
# 重新构建 Dockerfile 并启动服务
#
sudo bash scripts/close.sh && sudo bash scripts/start.sh

#
# 跳过构建 Dockerfile 并启动服务
#
sudo bash scripts/close.sh --no-clean && sudo bash scripts/start.sh --no-build
```

## Build Environment Setup

```bash



#
# 3. 安装 python 依赖
#
RUN python3 -m pip install --upgrade pip setuptools setuptools_rust dfss -i https://pypi.tuna.tsinghua.edu.cn/simple

#
# 4. 安装 bsp 依赖
#
RUN mkdir /env && pushd /env/ \
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
# 1. 下载源码仓库
#
cd ./volumes/env
git clone https://github.com/sophgo/bootloader-arm64.git
git clone https://github.com/sophgo/linux-arm64.git
git clone https://github.com/sophgo/libsophon.git

#
# 1. 进入容器
#
docker exec -it sophon-bsp-container bash

#
# 8. 添加环境变量并验证（逐条执行）
#
ls /env/gcc-linaro-6.3.1-2017.05-x86_64_aarch64-linux-gnu/bin
export PATH="$PATH:/env/gcc-linaro-6.3.1-2017.05-x86_64_aarch64-linux-gnu/bin"
echo $PATH
locale-gen en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US:en
export LC_ALL=en_US.UTF-8
locale

#
# 9. 加载编译脚本并执行
#
cd /env
source /env/bootloader-arm64/scripts/envsetup.sh
build_bsp_without_package
```
