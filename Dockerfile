FROM alpine:3.22

RUN apk add --no-cache \
    bash \
    git \
    py3-pip \
  && python3 -m pip install --break-system-packages \
    git+https://github.com/ros-infrastructure/bloom@master \
    rosdep
RUN rosdep init

COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
