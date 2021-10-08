FROM ruby:2.7-slim

WORKDIR /app

RUN apt-get update && apt-get -y upgrade && \
    apt-get install --no-install-recommends -y \
      build-essential \
      # git is required for installing gems
      git && \
      apt-get clean && rm -rf /var/lib/apt/lists/*

ADD ./Gemfile /app/
ADD ./faraday-panoptes.gemspec /app/
ADD ./ /app

# ensure we use a newer version of rubygems / bundler
RUN gem update --system

RUN bundle config --global jobs `cat /proc/cpuinfo | grep processor | wc -l | xargs -I % expr % - 1`
RUN bundle install
