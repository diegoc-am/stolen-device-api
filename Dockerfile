FROM ruby:2.6.3-alpine

ADD Gemfile /app/
ADD Gemfile.lock /app/

RUN apk --update add --virtual build-dependencies ruby-dev build-base mariadb-connector-c mariadb-dev
RUN gem install bundler
RUN cd /app ; bundle install --without development test

ADD config.ru /app
ADD src/ /app/src
RUN chown -R nobody:nobody /app
USER nobody
EXPOSE 8080
WORKDIR /app
