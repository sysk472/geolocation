FROM ruby:3.0.3

LABEL maintainer="sysk472"

COPY Gemfile* /usr/src/app/
WORKDIR /usr/src/app
RUN gem install bundler
RUN bundle install
COPY . /usr/src/app

CMD ["rails", "s", "-b", "0.0.0.0"]
