FROM ruby:2.4.2-slim-stretch
MAINTAINER NuRelm <development@nurelm.com>

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get install -yq \
    build-essential zlib1g-dev libreadline6-dev libyaml-dev libssl-dev \
    locales libsqlite3-dev sqlite3 \
    git libcurl3 libcurl3-gnutls libcurl4-openssl-dev

## set the locale so gems built for utf8
RUN dpkg-reconfigure locales && \
    locale-gen C.UTF-8 && \
    /usr/sbin/update-locale LANG=C.UTF-8
ENV LC_ALL C.UTF-8

## help docker cache bundle
WORKDIR /tmp
COPY ./Gemfile /tmp/
COPY ./Gemfile.lock /tmp/

RUN bundle install

WORKDIR /app
COPY ./ /app

ENTRYPOINT [ "bundle", "exec" ]
CMD [ "foreman", "start" ]
