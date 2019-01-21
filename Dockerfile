FROM busybox:1 AS fetch

ARG HUGO_VERSION=0.53
ARG S3DEPLOY_VERSION=2.2.0

ADD https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_${HUGO_VERSION}_Linux-64bit.tar.gz /hugo.tar.gz
RUN tar -zxf hugo.tar.gz
ADD https://github.com/bep/s3deploy/releases/download/v${S3DEPLOY_VERSION}/s3deploy_${S3DEPLOY_VERSION}_Linux-64bit.tar.gz /s3deploy.tar.gz
RUN tar -zxf s3deploy.tar.gz

RUN ["/s3deploy", "-V"]
RUN ["/hugo", "version"]

FROM alpine:3.8

RUN apk -U --no-cache add git make inotify-tools

COPY --from=fetch /hugo /bin/hugo
COPY --from=fetch /s3deploy /bin/s3deploy

VOLUME /data
WORKDIR /data

ENTRYPOINT ["make"]
