FROM ruby:2.4.1

RUN apt-get update -qq && \
    apt-get install -y build-essential libpq-dev nodejs

RUN mkdir /app
WORKDIR /app

ADD Gemfile .
ADD Gemfile.lock .

ENV DOCKER=true \
    BUNDLE_JOBS=4

RUN bundle install
