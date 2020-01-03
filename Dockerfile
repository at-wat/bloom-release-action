FROM alpine:3.10

RUN apk add --no-cache \
    bash \
    py3-pip \
  && pip3 install bloom

COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
