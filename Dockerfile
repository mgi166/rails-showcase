FROM ruby:2.4.1

RUN apt-get update -qq && \
    apt-get install -y build-essential libpq-dev nodejs

RUN mkdir /app
WORKDIR /app

ENV DOCKER=true \
    BUNDLE_JOBS=4 \
    BUNDLE_PATH=/bundle
