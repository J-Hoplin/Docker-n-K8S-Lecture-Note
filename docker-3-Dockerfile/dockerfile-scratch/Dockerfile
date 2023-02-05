FROM ubuntu
LABEL maintainer="hoplin"
RUN apt-get update\
    && apt-get upgrade -y\
    && apt-get install vim git apache2 -y

COPY ./index.html /var/www/html/index.html
ADD ./foo.js /var/www/html/foo.js

WORKDIR /var/www/html
EXPOSE 80

CMD [ "-D","FOREGROUND" ]
ENTRYPOINT [ "apachectl" ]