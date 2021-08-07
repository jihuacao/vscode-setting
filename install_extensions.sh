echo ${1}
if [ ${1} = "local" ]
then
    # 获取每一行然后运行
    while read in; do echo $in; code --install-extension $in; done < extensions-local.list
    #while read in; do echo $in; done < extensions-local.list
else
    if [ ${1} = "remote" ]
    then
        while read in; do code --install-extension $in; done < extensions-remote.list
    fi
fi