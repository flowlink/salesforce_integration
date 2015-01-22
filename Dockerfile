FROM debian:jessie
MAINTAINER Ric Lister, ric@spreecommerce.com

ADD https://33a6871815e79f57702b-41c4a87573b0a371a9ac50d3802e995d.ssl.cf2.rackcdn.com/ruby2.0_2.0.0-p481_amd64.deb /tmp/
RUN dpkg -i /tmp/ruby2.0_2.0.0-p481_amd64.deb && rm -f /tmp/ruby2.0_2.0.0-p481_amd64.deb

RUN apt-get update && apt-get install -y \
    build-essential zlib1g-dev libreadline6-dev libyaml-dev libssl-dev \
    git

## nokogiri deps
RUN apt-get install -y libxslt-dev libxml2-dev

RUN gem install bundler --no-rdoc --no-ri

## help docker cache bundle
WORKDIR /tmp
ADD ./Gemfile /tmp/
ADD ./Gemfile.lock /tmp/
RUN bundle install
RUN rm -f /tmp/Gemfile /tmp/Gemfile.lock

WORKDIR /app
ADD ./ /app

EXPOSE 5000

ENTRYPOINT [ "bundle", "exec" ]
# CMD [ "foreman", "start" ]

## this is a nasty hack, but without it foreman throws:
## `setpgrp': Operation not permitted (Errno::EPERM)
CMD [ "bash -c 'true && foreman start'"]
