# 使用 Ubuntu 作为基础镜像
FROM ubuntu:20.04

# 设置环境变量，避免交互式安装
ENV DEBIAN_FRONTEND=noninteractive

# 安装 NGINX 和编译 RTMP 模块的依赖
RUN apt-get update && apt-get install -y \
    build-essential \
    libpcre3 libpcre3-dev \
    libssl-dev \
    zlib1g zlib1g-dev \
    git \
    wget \
    curl \
    libnginx-mod-rtmp \
    && rm -rf /var/lib/apt/lists/*

# 下载并解压 NGINX 和 RTMP 模块的源码
WORKDIR /tmp
RUN wget http://nginx.org/download/nginx-1.25.0.tar.gz \
    && tar -zxvf nginx-1.25.0.tar.gz \
    && rm nginx-1.25.0.tar.gz

# 获取并编译 RTMP 模块
RUN git clone https://github.com/arut/nginx-rtmp-module.git

# 编译和安装 NGINX
WORKDIR /tmp/nginx-1.25.0
RUN ./configure --with-compat --add-module=/tmp/nginx-rtmp-module
RUN make
RUN make install

# 清理
RUN rm -rf /tmp/nginx-1.25.0 /tmp/nginx-rtmp-module

# 创建 HLS 目录
RUN mkdir -p /tmp/hls

# 暴露所需端口
EXPOSE 1935 8080

# 设置工作目录
WORKDIR /usr/local/nginx

# 启动 NGINX
CMD ["sbin/nginx", "-g", "daemon off;"]
