FROM node

LABEL maintainer="Hoplin"
LABEL email="jhoplin7259@gmail.com"

WORKDIR /sql-connect

COPY . .

RUN npm init -y\
    && npm i mysql2

ENTRYPOINT [ "/bin/bash" ]