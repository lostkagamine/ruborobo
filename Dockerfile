# ruborobo dockerimage
# i think made by ry00001
FROM ruby:alpine
ENV DOCKER true
RUN apk update && \
    apk upgrade && \
    apk add alpine-sdk
COPY . /usr/src/ruborobo
WORKDIR /usr/src/ruborobo
RUN bundle install
RUN gem update
RUN apk del alpine-sdk
# why didn't entrypoint have exec perms
# i blame windows
ENTRYPOINT ["/usr/src/ruborobo/entrypoint.sh"]
