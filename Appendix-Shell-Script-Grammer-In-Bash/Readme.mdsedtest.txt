Shell Script Grammer in bash
===
***
- Author : 홍익대학교 소프트웨어융합학과 윤준호(Hoplin)
***
## Linux Shell & Kernel
운영체제란, 컴퓨터 시스템 자원을 효율적으로 관리하며, 효과적으로 사용할 수 있도록 환경을 제공하며 하드웨어와 사용자간의 인터페이스 역할을 하는 시스템 프로그램의 일종이다. 그리고 이 운영체제는 `Kernel`과 `Shell` 두개로 나뉜다. 

![](./img/1.png)

### 커널
커널은 운영체제의 `엔진`과 같은 역할을 하는 핵심이다. 소프트웨어와 하드웨어간의 의사소통을 관리하며, 입출력 및 프로세스, 시스템 리소스를 관리하고 소프트웨어의 요청을 CPU, 메인메모리와 같은 하드웨어가 처리할 수 있도록 요청을 변경하는 역할을 한다. 커널은 컴퓨터 부팅시 부트로더에 의해 로드되 메모리에 항시 상주한다.

### 쉘
커널은 봤듯이 매우 중요한 역할을 하는 소프트웨어이다. 그렇기에 악의적인 사용자가 진입하여 조작하면, 시스템에 치명적인 결함을 만들 수 있다. 쉘은 응용프로그램과 쉘 사이에 존재하면서 명령어와 커널이 대화할 수 있도록 도와준다. 응용프로그램에서 명령을 보내면, 쉘은 해당 명령을 해석하여 커널로 보내는것이다. 그리고 쉘에는 다양한 종류가 있다.

- /bin/sh
- /bin/bash
- /bin/csh
- /bin/zsh

...etc
대부분의 리눅스는 기본적으로 `bash쉘`을 기본쉘로 사용한다. 결론적으로 우리는 리눅스 명령어들을 `쉘을 통해 입력`해 운영체제를 조작하는것이다. 그리고 이 명령어들을 나열하여 하나의 뭉치로 만들어 하나의 명령어처럼 실행하는것을 `Shell Script`라고 한다. 사용하는  리눅스 환경에서 자신이 사용하고 있는 쉘 종류를 보기 위해서는 아래와 같은 명령어를 입력하면 된다.
```
echo $SHELL
```

## Docker, K8S를 사용할 때 왜 Shell문법이 필요할까?

기본적으로 Docker는 리눅스 기반이다. 그렇기에 이미지 생성시 `bash shell`을 주로 사용한다. 예를들어 이미지를 만들때 패키지 매니저를 업데이트 하고, vim, gcc와 같은 부가적인 설치가 이미지를 만들때 진행해야한다고 가정을 한다거나, 웹에서 압축파일을 다운로드 하여 해제를 하여 특정 디렉토리에 파일을 넣어놓아야 한다거나 하는 등의 처리는 모두 쉘 명령어로 처리해 주어야한다. 아래 코드는 필자가 작성해본 도커파일의 예시이다. 자세히 보면 각각 모두 리눅스 쉘에서 따로 쓰는 명령어이다. 맨 마지막에 문장같은 경우에는 for문이다. 이 또한 쉘 문법중 하나이다. 도커를 제대로 활용하기 위해서는 `리눅스 명령어에 익숙해져야하며`,`쉘 문법에도 익숙해지면 활용도가 올라간다`. 여기서 모든 내용을 다룰 수는 없지만 기본적인것을 다루어볼 것이며, 이 부록은 앞으로 조금씩 업데이트 해나갈 예정이다.

```Dockerfile
...
RUN apt-get install git gcc libaio1 wget unzip php-dev php-pear build-essential curl vim -y
# Restart apache2
RUN service apache2 restart
# Install SSH
RUN apt-get install openssh-server -y

# Setting Oracle Client and OCI8
RUN mkdir -p /usr/lib/oracle/client\
&& cd /usr/lib/oracle/client\
&& wget https://download.oracle.com/otn_software/linux/instantclient/191000/instantclient-basic-linux.x64-19.10.0.0.0dbru.zip\
&& wget https://download.oracle.com/otn_software/linux/instantclient/191000/instantclient-sdk-linux.x64-19.10.0.0.0dbru.zip\
&& for i in instantclient*zip; do unzip $i; done\
...
```

### File Descriptor 알아보기
파일 디스크립터란, 표준 입력과 표준 출력, 표준 에러를 쉘이나 시스템 프로그래밍에서 숫자로 표현하는것을 의미한다.파일 디스크립터의 종류는 아래와 같다. 

|파일디스크립터|이름|용도|표준장치|
|:---:|:---:|:---:|:---:|
|0|stdin|명령어에 입력될 내용을 저장|키보드|
|1|stdout|명령어에서 출력될 내용을 저장|화면|
|2|stderr|명령어에서 출력될 에러메세지 저장|화면|
사용자는 일련번호를 이용하여 입출력 장치를 리다이렉션 해줄 수 있다. 


## Bash Shell 문법

- `>`
    - 출력 리다이렉션 연산자이다. 명령의 표준 출력을 파일로 저장한다. 파일을 덮어씌우며, 파일이 없을시 새 파일을 생성한다.
    - 예시 
        ```
        echo "hello" > ex.txt
        ```
- `<`
    - 입력 리다이렉션. 파일의 내용을 읽어 표준 입력으로 사용한다.
    - 예시
        ```
        cat < ex.txt
        ```
- `>>`
    - `>`와 동일하게 명령의 표준 출력을 파일로 저장한다. `>`와 달리 파일 뒷내용에 내용을 추가하며, 파일이 존재하지 않으면 새로 생성한다.
    - 예시 
        ```
        echo "new text" >> ex.txt
        cat ex.txt
        ```
- `2>`
    - 명령 실행의 표준 에러를 파일로 저장한다 `>`의 역할은 위와 동일하다
    - 예시
        ```
        ca ex.txt 2> err.txt
        cat err.txt

        // 결과
        zsh: command not found: ca
        ```
- `2>>`
    - 명령 실행의 표준 에러를 파일로 저장한다. `>>`의 역할은 위와 동일하다
    - 예시
        ```
        gcc 2>> err.txt
        cat err.txt

        // 결과
        zsh: command not found: ca
        clang: error: no input files
        ```

- `&>` & `&>>`
    - 표준 출력과 표준 에러를 모두 파일로 저장한다. `>`, `>>`의 역할은 위와 동일하다
    - 예시
        ```
        ec "example error" &> err.txt
        echo "Hello world" &>> err.txt

        // 결과
        zsh: command not found: ec
        Hello world
        ```

- `1>&2` & `1>>&2`
    - 표준 출력을 표준 에러로 보낸다. 아래 예시의 경우 `echo "hello world"`는 일반적인 표준 출력이 된다. 하지만, `1>&2`에 의해 표준 출력이 표준 에러로 변환되고(리다이렉션) `2>`에 의해 `error_test.txt`에 저장된다. `>`,`>>`의 역할 또한 위와 동일하다
    - 예시
        ```
        echo "hello world" 2> error_test.txt 1>&2
        cat error_test.txt

        // 결과
        hello world
        ```

- `2>&1` & `2>>&1`
    - 표준 에러를 표준 출력으로 보낸다. 아래의 경우에는 `gcc` 명령에 인자를 주지 않아 오류가 나야한다. 하지만, `2>&1`에 의해 표준 에러는 표준 출력으로 리다이렉션 되고 `/dev/null`로 보내졌기 때문에 아무것도 출력하지 않는것이다. `/dev/null` 파일은 항상 비어있고, 이 파일에 전송된 표준 출력 데이터는 항상 버려진다. 출력값을 출력하고 싶지 않은 경우 사용하기 좋다

    - 예시
        ```
        gcc > /dev/null
        // 결과
        clang: error: no input files

        gcc > /dev/null 2>&1
        // 결과 : 출력없음
        ```
- `|`
    - 파이프 연산자이다. 표준 출력을 다른 명령의 표준 입력으로 보낸다. 아래 예시는 `ps -ef`의 결과를 `grep`명령의 표준 입력으로 보내는것이다.
    - 예시
        ```
        ps -ef | grep .py
        ```
- `$`
    - 변수를 사용할떄 사용한다. 값을 저장할때는 붙이지 않아도 되지만, 변수를 쓸때는 `$`를 붙여쓴다
    - 예시    
        ```
        ex="example"
        echo "This is $ex"
        ```
- `$()`
    - 명령실행의 결과를 변수화 시킨다. 즉, 명령의 실행 결과를 변수에 저장하거나 다른 명령의 매개변수로 넘길 수 있다는 의미이다. 아래 예시에서 `$`앞에 `\`를 붙여준 이유는 쉘에서는 문법에 사용되는 문자를 순수 문자열로 사용하기 위해서 `\`를 붙여주어야 하기 때문이다.
    - 예시
        ```
        echo_test=$(echo "value from \$()")
        echo $echo_test
        ```
- ` `` `
    - `$()`와 동일한 역할을 한다.
    - 예시
        ```
        echo `date`
        ```
- `&&`
    - 한줄에 여러 명령을 실행한다. 다만 먼저 배치된 명령어가 오류가 없어야 다음 명령으로 넘어간다
    - 예시
        ```
        docker stop attach-test && docker rm attach-test
        ```
- `;`
    - 한줄에서 여러 명령을 실행한다. `&&`와 달리 오류가 있어도 다음 명령으로 넘어간다.
    - 예시
        ```
        ech "wrong echo" ; echo "correct echo"

        // 결과
        correct echo
        ```
- `''`
    - 문자열을 표현한다. 변수를 변수의 값으로 변환하지 못하며, `$()`, ` `` `등 명령의 실행값 또한 치환하지못한다.
    - 예시
        ```
        echo '$SHELL'

        // 결과
        $SHELL
        ```
- `""`
    - 문자열을 표현한다. `''`와 달리 변수의 원래 값으로 치환이 가능하며, `$()`와   ` `` `를 통한 명령의 실행 결과도 치환할 수 있다.
    - 예시
        ```
        echo "$SHELL"
        echo "$(ls)"
        ```
- `\`
    - 작은따옴표 안에서 큰따옴표를 사용하거나, shell 문법에 사용되는 특수문자를 문자열로 사용하기 위해 사용한다.
    - 예시
        ```
        echo 'example \"string\"'
        echo "\$pecial \$ymbolic"
        ```
- `{start..end}`
    - 연속된 숫자를 표현한다. 일종의 배열이다.
    - 예시
        ```
        echo {1..20}

        // 결과
        1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20
        ```
- `{str,str}`
    - `{}`안에 문자열을 여러개 지정해 명령 실행 횟수를 줄일 수 있다. 주의할 점은 `{}`안에 문자열은 `쉼표로 구분`하며 각 단어간 간격이 있어서는 안된다. 아래 예시에서는 여러개의 파일을 한번에 `copy-file`디렉토리로 옮기는 예시이다.
    - 예시
        ```
        mkdir copy-file
        cp ./{err.txt,ee.txt,ex.txt} ./copy-file
        ```
- `if`
    - 조건문이다. 변수와 변수 변수와 문자열을 비교할때 주로 사용된다. 형태는 아래와 같이 작성한다. 주의할 점은 조건식과 조건식을 감싸는 `[]`는 양옆에 한칸씩 띄워주어야 한다는것이다.
        ```bash
        if [ 조건식 ];
        then
            명령어
        elif;
        then
            명령어
        else
            명령어
        fi
        ```
    - 예시
        ```
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
        ```
    - if문의 비교연산자는 아래와같은 것들이 있다.
        - 숫자비교
            - `-eq` : 같다
            - `-ne` : 같지않다
            - `-gt` : 초과
            - `-ge` : 이상
            - `-lt` : 미만
            - `-le` : 이하
        - 문자열비교
            - `=`,`==` : 같다
            - `!=` : 같지않다
            - `-z` : 문자열이 NULL인경우
            - `-n` : 문자열이 NULL이 아닌경우
- `for`
    - 반복문이다. 변수 안에있는 값을 반복하거나 범위를 지정해 반복할 수 있다. 형식은 아래와 같다.
        ~~~bash
        // 형식 1
        for ~ in ~
        do
            명령어
        done

        // 형식 2
        for ((초기화;종료조건;증감연산))
        do
            명령어
        done
        ~~~
    - 예시
        ~~~bash
        // 형식 1
        for i in $(ls)
        do
            echo $i
        done

        // 형식 2
        for ((i=0;i<20;i++))
        do
            echo $i
        done
        ~~~
- `while`
    - 반복문이다. 형식은 아래와 같으며, `조건식을 사용하지 않는 경우 무한루프로 작동`하고 연산자는 `if`문과 동일하다
        ~~~
        while [ 조건문 ]
        do
            명령어
        done
        ~~~
    - `expr`은 연산을 도와주는 내장 명령어이다. 사용할 수 있는 연산은 아래와 같다.
        - 산술 : +,-,*,/,%
        - 논리 : |, &
        - 관계 : =, >, >=, <, <=, !=
        - 문자열 : `:`
    - 예시
        ~~~bash
        i=1
        while [ $i -le 10 ]
        do
            echo $i
            i=$(expr $i + 1)
        done
        ~~~
- `<<EOF ~~ EOF`
    - 여러 줄의 문자열을 명령의 표준 입력으로 보낼때 사용한다.
    - 예시
        ~~~bash
        cat > justsave.txt <<EOF
        This is string written with EOF
        Multi line
        Typing
        EOF
        ~~~
- `export`
    - 설정한 값을 환경변수로 만드며 형식은 아래와 같다.
        ~~~bash
        export (variable)=(value)
        ~~~
    - 예시
        ~~~bash
        export EXVAR="example variable"
        echo $EXVAR
        ~~~
- `sed`
    - 텍스트 파일에서 문자열을 변경한다. `-i`옵션을 붙이지 않으면, 변경 후의 결과를 출력만 하고, 텍스트파일에 적용이 되지 않는다. 텍스트 파일에 적용을 하기 위해서는 `-i`옵션을 주어야한다. 만약 `/`를 문자열로 사용하고 싶다면 `\/`와 같이 작성해주면 된다.
        ~~~bash
        sed (-i | 옵션없음) "s/<찾을문자열>/<바꿀문자열>/g"
        ~~~
    - 예시
        ~~~bash
        echo "hello world" > sedtest.txt
        sed -i "s/hello/new/g" sedtest.txt
        cat sedtest.txt
        
        // 결과
        new world
        ~~~