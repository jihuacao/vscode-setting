if [ $0=="local" ]
then
    # 获取每一行然后运行
    while read in; do code --install-extension $in; done < extensions-local.list
else
    if [ $0 == "remote" ]
    then
        while read in; do code --install-extension $in; done < extensions-remote.list
    fi
fi