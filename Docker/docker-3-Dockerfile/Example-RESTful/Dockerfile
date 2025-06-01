FROM node

LABEL maintainer="Hoplin"

RUN apt-get update\
    && apt-get upgrade -y\
    && mkdir api

ENV EXAMPLEVAR='example variable from dockerfile'

COPY ./example.txt .

WORKDIR /api

# 여기서부터 명령어가 실행되는 컨테이너 내부 디렉토리는 어디일까?

EXPOSE 3000
VOLUME [ "/api" ]

# docker run에 실행 인자를 전달하면 CMD의 값은 무시된다
CMD [ "run" ] 

ENTRYPOINT [ "bash" ]

