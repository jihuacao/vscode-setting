extension_diff=`diff <(cat extensions-local.list) <(code --list-extensions --show-versions)`
echo $extension_diff