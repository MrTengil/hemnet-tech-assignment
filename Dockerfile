FROM ruby:3.3.1

RUN apt-get update -qq && \
    apt-get install -y build-essential libsqlite3-dev nodejs

WORKDIR /app

COPY Gemfile* ./
RUN bundle install
COPY . .
