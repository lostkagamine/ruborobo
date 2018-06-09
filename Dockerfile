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
RUN apk del alpine-sdk
CMD ["ruby", "/usr/src/ruborobo/bot.rb"]