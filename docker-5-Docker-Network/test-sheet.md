Scenario Test
===
***
- Title : Week3,4 Review test
- 출제자 : 윤준호
***
**각 문제를 읽은 후 질문에 답하시오**

1. `docker diff` 명령어가 출력하는 플래그를 모두 쓰고, 각 플래그들이 가지고 있는 의미에 대해 설명하시오

2. `my-volume`이라는 도커 볼륨을 생성하시오.

3. Volume Container 시나리오다. 아래 시나리오 순서대로 명령어 혹은 Dockerfile을 작성하시오. **볼륨 컨테이너에 연결될 호스트와 연결할 디렉토리 이름은 `/dir/my-directory`이다**.

    - 도커 이미지를 만든다. 아래 조건만 만족하면 된다
        - `ubuntu:14.04`를 사용한다
        - 호스트에 연결될 컨테이너 디렉토리는 `/container-dir`이다.
    - 도커 이미지를 `ubuntu-volume`이라는 이름으로 빌드하고, 컨테이너를 실행한다.컨테이너 이름은 `first-level-container`이다.
    - 위에서 빌드한 이미지를 가지고`first-level-container`로 부터 볼륨을 공유받는 두개의 컨테이너를 생성, 및 실행한다.

4. 다음 질문에 답하시오

    4-1. 아래 조건에 맞게끔 Dockerfile을 작성하시오 
    - 1\) 이미지는 `ubuntu:14.04` 이미지를 사용할 것이다
    - 2\) 이 이미지의 메타데이터로 자신의 이름과 이메일을 적어놓을것이다.
    - 3\) 아래 명령어들을 실행한다.
        - apt-get update
        - apt-get upgrade -y
        - apt-get install -y vim git
    - 4\) 호스트 머신의 `/mydir/myfile.txt` 파일을 컨테이너의 현재 위치로 복사한다
    - 5\) 호스트 머신의 `/mydir/myzip.tar.gz`파일을 컨테이너 현재 위치에 압축을 해제하여 복사한다
    - 6\) 컨테이너 기본 디렉토리를 `/test-dir`로 이동한다
    - 7\) Github의 파일중 `http://~~~/a.py` 파일을 현재 위치로 복사한다
    - 8\) `/test-dir`을 호스트와 연결할 것이다
    - 9\) 포트는 `80`,`9000`포트를 노출할 것이다.
    - 10\) 컨테이너 기본 실행 명령어는 `python3 a.py`이다. `CMD`, `ENTRYPOINT`두개를 활용해서 표현하라
    
    4-2. 4-1의 `3)`과정에서 명령어 실행시 `-y`플래그를 붙이는 이유가 무엇인가?

    4-3. 4-1의 도커파일을 실행하는 명령어를 작성하시오. 단, 컨테이너의 기본 실행 명령어는 유지되어야 한다.

5. 다음 물음에 답하시오

    5-1. 아래 시나리오대로 명령어를입력하고 `docker commit`을 활용하여 이미지를 만든다

    - 1\) `ubuntu:14.04`이미지의 컨테이너를 실행한다
    - 2\) `test-directory`라는 이름의 디렉토리를 생성한다
    - 3\) `test-directory`안에는 `hello world`를 출력하는 쉘스크립트인 `test.sh`가 있어야한다
    - 4\) 컨테이너를 종료하고 컨테이너를 이미지화 시킨다. 단 조건이 있다.
        - 이미지를 커밋한 사람 : Hoplin
        - 커밋 메세지 : "new image"
        - 이미지 이름 : container2image
        - 이미지 태그 : ver1
    5-2. 위 과정대로 이미지를 만든 후, 컨테이너를 실행하였다. 그리고 `test-directory/test.sh` 파일을 변경하였다. `docker diff`를 했을때 `test-directory/test.sh`는 어떤 플래그를 띄고있는가?
