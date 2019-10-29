FROM nurelmdevelopment/ruby-base-image

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
