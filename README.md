# shadowsocks-kcptun-docker

![docker-pulls](https://img.shields.io/docker/pulls/zetaplusae/shadowsocks-kcptun)

集成kcptun的Shadowsocks镜像

## 运行方式

以下命令会分别在`8388`、`29900`（udp）端口上启动Shadowsocks和kcptun，Shadowsocks的密码为`passw0rd`，加密方式为`aes-256-cfb`。
```
docker run -d -p 8388:8388 -p 29900:29900/udp zetaplusae/shadowsocks-kcptun
```

## 选项

| 选项 | 参数说明 | 默认值 |
| ------------- |:-------------:| -----:|
| --help | 帮助 | 无 |
| -m, --ss-method METHOD | shadowsocks的加密算法 | aes-256-cfb |
| -p, --ss-password PASSWORD | shadowsocks的密码 | passw0rd |
| -s, --kcptun-secret PASSWORD | kcptun密码 | it's a secrect |
| -c, --kcptun-crypt CRYPT | kcptun加密算法，详见[kcptun](https://github.com/xtaci/kcptun)的--crypt参数 | aes |


示例：
```
docker run -d -p 8388:8388 -p 29900:29900/udp zetaplusae/shadowsocks-kcptun \
    -m 'aes-256-cfb' -p 'passw0rd' \
    -s "it's a secrect" -c 'aes'
```

## 端口

| 服务        | 端口           | 类型  |
| ------------- |:-------------:| -----:|
| shadowsocks | 8388 | TCP |
| kcptun | 29900 | UDP |
