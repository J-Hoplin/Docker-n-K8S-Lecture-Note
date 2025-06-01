Scenario Test
===
***
- Title : Week2 Review test
- 출제자 : 윤준호
***
**각 문제의 조건에 맞게끔 명령어를 작성하고, 추가 질문이 있을시, 추가문제도 함께 답변하십시오.**

1. httpd 도커이미지를 사용할 것이다. httpd는 Apache 웹서버이미지이다. 단 2.4-bullseye라는 태그를 가진 httpd이미지를 사용할 것이다. 이미지를 불러오자. Docker가 이미지를 기본적으로 불러오는 곳은 어디인가?


2. 컨테이너를 실행하려고 한다. 아래 주어진 조건들을 모두 고려하여 명령어를 작성하시오(5번 새끼문제도 답변하시오)

    1. 컨테이너 이름은 my-webserver이다.

    2. httpd는 80번 포트를 외부와 연결시킬 수 있다. 나는 이를 호스트의 7000번 포트에 연결하여 내 웹브라우저에서 웹페이지를 확인할 것이다.

    3. 이 테스트파일에 있는 디렉토리에 밑에 주어진 html코드를 index.html로 저장하고 html파일이 저장된 디렉토리와 컨테이너의 /var/www/html디렉토리와 연결하려고 한다. 

        ```html
        <!-- index.html -->
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Test page</title>
        </head>

        <body>
            <h1>Week3 : Review test of week2</h1>
            <p>If you see this page in your host machine's web browser, you got it!</p>
        </body>

        </html>
        ```

    4. 컨테이너는 'EXAMPLE_VARIABLE'이라는 환경변수를 가지며, 이의 값은 'test'이다. 

    5. 컨테이너 실행 모드 Detach Mode를 사용한다. 출제자는 왜 Detach Mode를 사용하여 컨테이너를 실행하였을까? 추측해보자

3. 컨테이너가 잘 생성되었는지 확인하려고 한다. 컨테이너 목록을 출력해보자

4. 웹브라우저에서 어떤 url을 입력해야 내 웹페이지를 볼 수 있는가?

5. 컨테이너 작동을 멈추려고 한다.

6. 컨테이너가 잘 정지되었는지 확인하려고 한다. 컨테이너 목록을 출력해보자

7. 컨테이너를 삭제한다

8. httpd 이미지를 삭제한다.