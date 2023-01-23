#!/bin/bash

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