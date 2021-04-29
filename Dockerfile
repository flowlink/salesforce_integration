FROM ruby:2.7-alpine
MAINTAINER NuRelm <development@nurelm.com>

RUN apk add --no-cache --update build-base libcurl linux-headers git shared-mime-info tzdata

WORKDIR /app
COPY ./ /app

RUN gem install bundler:1.16.0
RUN bundle install --jobs 5

RUN apk del build-base linux-headers git

ENTRYPOINT [ "bundle", "exec" ]
CMD [ "foreman", "start" ]
