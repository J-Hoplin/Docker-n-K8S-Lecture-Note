# 이 이미지는 빌드하지 마세요. 단순히 명령어들을 살펴보기 위한 예시 파일입니다.

# 기반 이미지 정의
FROM ubuntu

# 이미지 메타데이터 설정
LABEL maintainer="Hoplin"
LABEL email="jhoplin7259@gmail.com"

# 환경변수 설정
ENV EXAMPLE_ENV 'example-environment-variable'

# ubuntu같은 경우, '/'가 기본 명령어 실행 디렉토리이다.
# 연쇄방식
RUN apt-get update\
    && apt-get upgrade -y
# 배열방식
RUN ["apt-get","install","vim","git","apache2","-y"]

# workdir 변경
WORKDIR /example-directory

# Add 명령어 사용해보기
# 위에서 WORKDIR를 /example-directory로 설정했기 때문에 밑에서의 명령어는 모두 /example-directory 디렉토리 기준으로 실행된다
# 현재디렉토리의 값을 의미하는 '.' 은 /example-directory 이 되는것이다.
# 파일 복사.
ADD ./add-example.txt ./changed-name.txt
# 디렉토리 복사
ADD ./add-example-directory ./add-example-directory
# URL형식의 파일 복사
ADD https://github.com/J-hoplin1/J-hoplin1/blob/master/README.md .
# 로컬 tar파일
ADD ./example_tar.tar .
# URL tar파일
ADD https://www.zlib.net/zlib-1.2.13.tar.gz .
# URL tar파일 하제
RUN apt-get install curl -y\
    && curl https://www.zlib.net/zlib-1.2.13.tar.gz | tar -xz

# COPY명령어
COPY ./ignoreEx ./ignoreEx

# Volume
VOLUME ['/dir1','/dir2','/dir3']

# Port expose
EXPOSE 5000 6000

ENTRYPOINT ["bash"]