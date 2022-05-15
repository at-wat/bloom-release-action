FROM nginx:1.21-alpine

RUN apk add --no-cache \
    fcgiwrap \
    git \
    git-daemon \
    gzip \
    make

COPY cache /usr/share/nginx/html/cache
RUN make -C /usr/share/nginx/html/cache
COPY repos /usr/share/nginx/html/raw

COPY 40-start-fastcgi.sh /docker-entrypoint.d
COPY default.conf /etc/nginx/conf.d

RUN git config --global user.email "you@example.com" \
  && git config --global user.name "Your Name"

COPY repos /repos
WORKDIR /repos

RUN for repo in *; \
  do \
    git -C ${repo} init; \
    git -C ${repo} add .; \
    git -C ${repo} commit -m "Initial"; \
    git -C ${repo} config core.bare true; \
    git -C ${repo} config http.receivepack true; \
    mv ${repo}/.git ${repo}.git; \
    rm -rf ${repo}; \
  done
