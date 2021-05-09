need=`diff <(cat extensions-local.list) <(code --list-extensions --show-versions)`
echo ${need}
need_extension=""
unneed_extension=""
direction=""
get_extension=0
extension_name=""
a=`echo ${need} | sed -e 's/\(.\)/\1 /g'`
#a=`$need | while read letter;  do echo "my letter is $letter" ; done`
echo $a
a="aaaaa"
echo ${#a}
echo ${a[@]}
for i in ${#a};
do
    #echo $var
    # 空格，如果direction==0，get_extension置0，\
    # 如果direction！=0 && extension_name！=0，direction也置0，完善extension收集 \
    # 如果direction！=0 && extension_name == ''，跳过继续执行
    echo 1
    echo $var
    if [ var == " " ]
    then
        if [ -z $extension_name ]
        then
            break
        else
            if [ $direction == "+" ]
            then
                echo install $extension_name
                need_extension=$need_extension $extension_name
            else
                echo uniinstall ${extension_name}
                unneed_extension=$unneed_extension $extension_name
            fi
            direction=0
            extension_name=""
            break
        fi
        break
    else
        # 字符=='<' || 字符=='>'，判断是曾还是减
        if [ var == "<" ]
        then
            direction="+"
            break
        fi
        if [ var == ">" ]
        then
            direction="-"
            break
        fi
        # 如果direction不为零，构建插件名称 如果direction！=0，则构建插件名称，\
        # 如果direction==0，则跳过混淆字符
        if [ direction != "" ]
        then
            extension_name=${extension_name}${var}
            break
        else
            break
        fi
    fi
done