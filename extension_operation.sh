# 指导方针:
#   保证remote-ssh与非remote-ssh同步，
#   同时remote-ssh中可以使用的extension在非remote-ssh中也可以使用，这意味着使用非remote-ssh作为指导的可行性
#   增加extension：
#       非remote-ssh中cup->非remote-ssh中增加插件->remote-ssh中force_remote
#   删除extension：
#       在非remote-ssh中cup->非remote-ssh中手动删除extension->
#       remote-ssh中force_remote
#   合并extension版本：
#       再非remote-ssh中cup->手动修改插件->force_local
#       ->remote-ssh中force_remote
#   代码测试：
#       备份extensinos-list->force_local->恢复extensino-list->cup->恢复extension-list->force_remote
echo ${1}

get_extensions_list(){
    file=${1}
    temp=($(code --list-extensions --show-versions))
    echo "${temp[*]}"
}

get_local_installed(){
    local temp
    temp=($(code --list-extensions --show-versions))
    echo "${temp[*]}"
}

get_remote_supposed(){
    local temp
    while read in; do temp=(${temp[*]} $in); done < extensions.list;
    echo "${temp[*]}"
}

print_list(){
    arr=(${1})
    for i in ${arr[*]};do
        echo ${i}
    done
}

compare(){
    arr_1=(${1})
    arr_2=(${2})
    local one_own
    local one_cap_two
    local two_own
    local found_in_two

    for one in ${arr_1[*]};do
        found_in_two="notfound"
        #echo "one:${one}"

        #echo "arr_2 size:${#arr_2[@]}"
        for ((two_index=0;two_index<${#arr_2[*]};two_index++));do
        #for two in ${arr_2[*]}
            #echo ${two_index}
            #echo ${arr_2[${two_index}]}
            if [[ ${one} == "${arr_2[${two_index}]}" ]];then
            #echo ${two}
            #if [ ${one}=${two} ]
                #echo "two:${arr_2[${two_index}]}"
                unset arr_2[${two_index}]
                arr_2=("${arr_2[@]}")
                one_cap_two="${one_cap_two}|${one}"
                found_in_two="found"
                break
            fi
        done 

        if [[ ${found_in_two} == "notfound" ]];then
            one_own="${one_own}<${one}"
        fi
    done
    two_own="${arr_2[*]}"
    two_own=$(echo ${two_own// />})
    two_own=">${two_own}"
    echo "${one_own} ${one_cap_two} ${two_own}"
}

extract_by_begin(){
    status=(${1})
    reg=${2}
    for s in ${status[*]};do
        if [[ ${s} == ${reg}* ]];then
            own=($(echo ${s//${reg}/ }))
            #print_list "${own[*]}"
        fi
    done
    # 关于在remote-ssh中生成的extensions.list第一行会有混淆信息，这里使用插件特有字符@来滤除
    for ((i=0;i<${#own[*]};));do
        if [[ ${own[${i}]} != *@* ]];then
            unset own[${i}]
            own=("${own[@]}")
        else
            let "i=${i}+1"
        fi
    done
    echo "${own[*]}"
}

diff(){
    #echo "local installed"
    local_installed=($(get_local_installed))
    #print_list "${local_installed[*]}"
    #echo ""

    #echo "remote supposed"
    remote_supposed=($(get_remote_supposed))
    #print_list "${remote_supposed[*]}"
    #echo ""

    #echo "status"
    status=$(compare "${local_installed[*]}" "${remote_supposed[*]}")
    #print_list "${status[*]}"
    echo "${status[*]}"
}

show_diff(){
    status=($(diff))
    one_own=$(extract_by_begin "${status[*]}" "\<")
    echo "one_own"
    print_list "${one_own[*]}"
    echo ""
    both=$(extract_by_begin "${status[*]}" "\|")
    echo "both"
    print_list "${both[*]}"
    two_own=$(extract_by_begin "${status[*]}" "\>")
    echo ""
    echo "two_own"
    print_list "${two_own[*]}"
}

cup(){
    status=($(diff))
    one_own=$(extract_by_begin "${status[*]}" "\<")
    both=$(extract_by_begin "${status[*]}" "\|")
    two_own=$(extract_by_begin "${status[*]}" "\>")
    for i in ${two_own[*]};do
        #ret=$(code --install-extension ${i})
        ret=`code --install-extension ms-vscode-remote.remote-ssh@0.65.7`
        for r in "${ret[*]}";do
            echo "ret:${r}"
        done
    done
}

force_local(){
    echo ""
}

force_remote(){
    status=($(diff))
    one_own=$(extract_by_begin "${status[*]}" "\<")
    both=$(extract_by_begin "${status[*]}" "\|")
    two_own=$(extract_by_begin "${status[*]}" "\>")
    echo ""
}

operation="${1}"
if [[ ${operation} == "show_diff" ]];then
    status=($(diff))
    one_own=$(extract_by_begin "${status[*]}" "\<")
    echo "one_own"
    print_list "${one_own[*]}"
    echo ""
    both=$(extract_by_begin "${status[*]}" "\|")
    echo "both"
    print_list "${both[*]}"
    two_own=$(extract_by_begin "${status[*]}" "\>")
    echo ""
    echo "two_own"
    print_list "${two_own[*]}"
fi
# 更新本地插件为remote与local的并集，同时更新remote插件列表文件
if [[ ${operation} == "cup_update" ]];then
    #code --list-extensions --show-versions > extensions.list
    show_diff
    cup
    show_diff
    echo ""
fi
# 更新本地插件为remote与local的并集，不更新remote插件列表
if [[ ${operation} == "cup" ]];then
    show_diff
    cup
    show_diff
fi
# 更新本地插件为remote与local的交集，同时更新remote插件列表
# 更新本地插件为remote与local的交集，同时更新remote插件列表
# 强制更新remote为本地插件列表
if [[ ${operation} == "force_local" ]];then
    show_diff
    force_local
    show_diff
fi
# 强制更新local为remote插件列表
if [[ ${operation} == "force_remote" ]];then
    show_diff
    force_remote
    show_diff
fi
#if [ ${1} = "local" ]
#then
#    # 获取每一行然后运行
#    while read in; do echo $in; code --install-extension $in; done < extensions-local.list
#    #while read in; do echo $in; done < extensions-local.list
#else
#    if [ ${1} = "remote" ]
#    then
#        while read in; do code --install-extension $in; done < extensions-remote.list
#    fi
#fi