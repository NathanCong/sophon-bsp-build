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
# 1. 进入容器
#
docker exec -it sophon-bsp-container bash

#
# 2. 下载 BSP_SDK
#
mkdir /env && pushd /env/ \
&& python3 -m dfss --url=open@sophgo.com:/sophon-bsp/BSP_SDK.zip \
&& 7z x BSP_SDK.zip \
&& mv 'BSP SDK'/* ./ \
&& rm -rf 'BSP SDK' \
&& rm -rf BSP_SDK.zip \
&& rm -rf memory_layout_modification_tool \
&& tar -xaf gcc-linaro-6.3.1-2017.05-x86_64_aarch64-linux-gnu.tar.xz

#
# 3. 下载 qt_fl2000
#
mkdir qt_fl2000 && pushd qt_fl2000 \
&& python3 -m dfss --dflag=sophgo-bsp-qt5-fl2000fb-toolchain \
&& tar -xaf *.tar.xz \
&& popd

#
# 4. 下载 qt_ms9132
#
mkdir qt_ms9132 && pushd qt_ms9132 \
&& python3 -m dfss --dflag=sophgo-bsp-qt5-ms9132-toolchain \
&& tar -xaf *.tar.xz \
&& popd \
&& popd

#
# 5. 添加环境变量并验证（逐条执行）
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
# 6. 下载 bootloader-arm64 仓库（可外部下载，然后复制进容器）
#
git clone https://github.com/sophgo/bootloader-arm64.git

#
# 7. 下载 linux-kernel 源码仓库（可外部下载，然后复制进容器）
#
git clone https://github.com/sophgo/linux-arm64.git

#
# 8. 下载 libsophon 源码仓库（可外部下载，然后复制进容器）
#
git clone https://github.com/sophgo/libsophon.git

#
# 9. 加载编译脚本
#
cd /env/bootloader-arm64
source scripts/envsetup.sh
build_bsp_without_package
```
