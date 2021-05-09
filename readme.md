# readme
同步方法，每次想更新配置，需要先从从远程拉取最新配置，然后更新到本地，然后手动更新本地配置，然后推送到远程中
## 查看当前配置与文件的差别

## 生成插件表
### 生成本机插件表
windows-git bash/linux-ternimal
```shell
bash generate_local_extension.sh
```
### 生成remote-ssh插件环境
打开remote工程，在remote-ssh中运行generate_local_extension.sh脚本，运行方法与本机方法一致
## 应用插件表
### 本机应用插件表
windows-git bash/linux ternimal
```shell
bash extensions_local_sync.sh
```
### remote环境应用插件表
打开remote工程，在remote-ssh中运行extensions_remote_sync.sh，运行方法与本机方法一致
