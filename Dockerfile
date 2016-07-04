FROM resin/rpi-raspbian
MAINTAINER Nuno Sousa <nunofgs@gmail.com>
RUN apt-get update &&\
    apt-get install -y --no-install-recommends git ca-certificates wget tar golang nginx libgcrypt20-dev &&\
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN echo "daemon off;" >> /etc/nginx/nginx.conf

#fix for long server names
RUN sed -i 's/# server_names_hash_bucket/server_names_hash_bucket/g' /etc/nginx/nginx.conf

# disable server_tokens
RUN { \
      echo 'server_tokens off;'; \
      echo 'client_max_body_size 100m;'; \
    } > /etc/nginx/conf.d/my_proxy.conf

ENV GOPATH /opt/go
ENV PATH $PATH:$GOPATH/bin
ENV VERSION 0.7.3
ENV DOWNLOAD_URL https://github.com/jwilder/docker-gen/releases/download/$VERSION/docker-gen-linux-armhf-$VERSION.tar.gz
ENV DOCKER_HOST unix:///tmp/docker.sock

RUN wget -qO- $DOWNLOAD_URL | tar xvz -C /usr/local/bin
RUN go get -u github.com/ddollar/forego

COPY data/ /opt/app
WORKDIR /opt/app

EXPOSE 80
ENV DOCKER_HOST unix:///tmp/docker.sock

CMD ["forego", "start", "-r"]
