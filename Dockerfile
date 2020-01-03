FROM alpine:3.10

RUN apk add --no-cache \
    bash \
    git \
    py3-pip \
  && pip3 install bloom rosdep
RUN rosdep init

COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
