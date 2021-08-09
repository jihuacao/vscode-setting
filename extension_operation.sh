echo ${1}

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
    echo ""
fi
# 更新本地插件为remote与local的并集，不更新remote插件列表
if [[ ${operation} == "cup" ]];then
    echo ""
fi
# 更新本地插件为remote与local的交集，同时更新remote插件列表
# 更新本地插件为remote与local的交集，同时更新remote插件列表
# 强制更新remote为本地插件列表
if [[ ${operation} == "force_local" ]];then
    echo ""
fi
# 强制更新local为remote插件列表
if [[ ${operation} == "force_remote" ]];then
    echo ""
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