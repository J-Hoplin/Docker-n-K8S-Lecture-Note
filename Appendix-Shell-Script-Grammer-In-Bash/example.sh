#!/bin/bash

# 실행해보기

ex="example"
echo "This is $ex"

echo_test=$(echo "value from \$()")
echo $echo_test

echo `date`

docker stop attach-test && docker rm attach-test

ech "wrong echo" ; echo "correct echo"

echo '$SHELL'

echo "$SHELL"
echo "$(ls)"

echo 'example \"string\"'
echo "\$pecial \$ymbolic"

echo {1..20}

a=10
b=20
if [ $a -lt $b ];
then
    echo "$a is lower than $b"
elif [ $a -gt $b ];
then
    echo "$a is greater than $b"
else
    echo "$a and $b is same"
fi

for i in $(ls)
do
    echo $i
done

for ((i=0;i<20;i++))
do
    echo $i
done

i=1
while [ $i -le 10 ]
do
    echo $i
    i=$(expr $i + 1)
done


cat > justsave.txt <<EOF
This is string written with EOF
Multi line
Typing
EOF

export EXVAR="example variable"
echo $EXVAR

echo "hello world" > sedtest.txt
sed -i "s/hello/new/g" sedtest.txt

name_of_function(){
    example_var="example_variable_in_function"
    echo $example_var
}

name_of_function

give_args(){
    echo $1
    echo $2
}

give_args "Args1" "Args2"

return_test(){
    return $(expr $1 + $2)
}
return_test 10 20
echo $?

return_test2(){
    echo Result is $(expr $1 + $2)
}
result=$(return_test2 40 50)
echo $result
