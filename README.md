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

## Others

```bash
#
# download build files
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
&& tar -xaf qt-5.14-amd64-aarch64-fl2000fb_v1.1.0.tar.xz \
&& popd \
&& mkdir qt_ms9132 && pushd qt_ms9132 \
&& python3 -m dfss --dflag=sophgo-bsp-qt5-ms9132-toolchain \
&& tar -xaf qt-5.14-amd64-aarch64-ms9132_v1.1.0.tar.xz \
&& popd \
&& popd
```
