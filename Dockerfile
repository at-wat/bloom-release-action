FROM alpine:3.15

RUN apk add --no-cache \
    bash \
    git \
    py3-pip \
  && python3 -m pip install \
    git+https://github.com/at-wat/bloom.git@use-empy-v3 \
    rosdep
RUN rosdep init

COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
