need=`diff <(cat extensions-local.list) <(code --list-extensions --show-versions)`
for var in $need
do
    echo $var
done