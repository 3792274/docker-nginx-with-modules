#!/usr/bin/bash

NGINX_VERSION=1.21.5;
TAG=base-$NGINX_VERSION-alpine;
GIT=https://github.com/nginxinc/docker-nginx.git;

USERID=s3792274;
MODULES=`pwd`/modules/;
DIR=`pwd`/github;
 
rm -rf $DIR && mkdir -p $DIR && cd   $DIR  && git clone $GIT && 
cd docker-nginx &&  git checkout -b $NGINX_VERSION && docker pull nginx:$NGINX_VERSION-alpine &&  docker tag  nginx:$NGINX_VERSION-alpine nginx:mainline-alpine &&
cd  modules && \cp -r $MODULES/* . &&
docker build --build-arg ENABLED_MODULES="echo fancy ndk lua auth-spnego brotli encrypted-session fips-check geoip geoip2 headers-more image-filter modsecurity njs opentracing passenger perl rtmp set-misc subs-filter xslt" -f Dockerfile.alpine -t $USERID/nginx . &&
docker run --rm  $USERID/nginx  nginx -V && docker run --rm  $USERID/nginx ls -alsh  /etc/nginx/modules/ && docker tag  $USERID/nginx  $USERID/nginx:$NGINX_VERSION &&
rm -rf DIR &&
docker push  $USERID/nginx:$NGINX_VERSION