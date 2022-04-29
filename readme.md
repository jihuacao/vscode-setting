# readme
## fit between windows and linux
脚本先在linux下进行测试，然后在windows下进行测试，当矛盾点出现时，通过判断系统类型进行分支处理

在windows下使用git的bash运行脚本，使用bash *.sh的方法运行
在linux中也是使用bash环境运行脚本
## 更新插件方法
linux下使用以下命令进行插件操作
```bash
bash extension_operation.sh **
```
* show_diff:bash extension_operation.sh show_diff
显示出本地安装的插件与extensions.list的差异
## 各插件作用
* Markdown All in One
  * markdown
* Markdown Preview Enhanced
  * 增强预览功能，替代vscode自带预览
* Markdown-pdf
  * markdown生成pdf jpeg png html等导出文件