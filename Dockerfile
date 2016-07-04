FROM resin/rpi-raspbian
MAINTAINER Nuno Sousa <nunofgs@gmail.com>
RUN apt-get update &&\
    apt-get install -y git mercurial golang nginx libgcrypt20-dev &&\
    apt-get clean

RUN echo "daemon off;" >> /etc/nginx/nginx.conf

#fix for long server names
RUN sed -i 's/# server_names_hash_bucket/server_names_hash_bucket/g' /etc/nginx/nginx.conf

ENV GOPATH /opt/go
ENV PATH $PATH:$GOPATH/bin
RUN go get -u github.com/jwilder/docker-gen && go get -u github.com/ddollar/forego

ADD data/ /opt/app
WORKDIR /opt/app

EXPOSE 80
ENV DOCKER_HOST unix:///tmp/docker.sock

CMD ["forego", "start", "-r"]
