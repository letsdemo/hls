# 使用Nginx RTMP和HLS.js搭建HLS演示环境

## 1. 引言
HTTP Live Streaming (HLS) 是一种广泛使用的流媒体传输协议，特别适合互联网上的视频直播和点播服务。为了演示HLS的工作流程，我们将使用 Nginx RTMP 模块作为服务器端来接收推流，并通过 OBS（Open Broadcaster Software）进行推流。最后，我们将使用 HLS.js 库在网页上播放这些流。

## 2. 环境准备
2.1 使用docker编译 Nginx 和 RTMP 模块

   * [Docker镜像文件](./Dockerfile)
   * 编译脚本
    ```bash
     docker build -t nginx-rtmp .
    ```

2.2 配置 Nginx RTMP
* 编辑 [Nginx 的配置文件](./nginx.conf)（通常位于 /usr/local/nginx/conf/nginx.conf）
  * 添加 RTMP 服务器配置
  * 添加hls配置

* 这段配置定义了一个名为 live 的 RTMP 应用程序，它将接收到的流转换为 HLS 格式，并存储在 /tmp/hls 目录中。同时，HTTP 服务器监听 8080 端口，提供对 HLS 分段文件的访问。

2.3 启动 服务：

* 使用[docker compose](docker-compose.yml)来编排容器
* 完成配置后，启动Docker服务,Docker服务会自动启动Nginx服务：

    ```
    docker-compose up -d
    ```


## 3. 推流设置
   
3.1 安装 OBS Studio
* 前往 OBS Studio 官方网站 下载并安装适用于您操作系统的版本。

3.2 配置 OBS 进行推流
* 打开 OBS Studio，点击“设置”->“流”，选择“自定义流密钥”作为服务类型，并填写如下信息：

  * 服务器：rtmp://<your-server-ip>:1935/live
  * 流密钥：stream （或任何您想要的字符串）
  * 点击“应用”保存设置，然后点击“开始推流”按钮开始向 Nginx 服务器推送视频流。

## 4. 播放设置
4.1 安装 HLS.js
HLS.js 是一个开源的 JavaScript 库，支持在不兼容原生 HLS 的浏览器中播放 HLS 流。您可以直接在HTML文件中引入 HLS.js：

   * [演示文件](./html/index.html)
   * 在浏览器中[打开 http://<your-server-ip>:8080](http://localhost:8080), 即可观看通过 OBS 推送的 HLS 流。

## 5. 结论
通过以上步骤，我们成功地搭建了一个简单的 HLS 演示环境，其中包括使用 Nginx RTMP 模块作为服务器端接收推流，使用 OBS Studio 进行推流，以及使用 HLS.js 在网页上播放这些流。这个环境不仅适用于学习和测试 HLS 协议，还可以作为实际项目的起点，进一步开发和完善更复杂的功能和服务。