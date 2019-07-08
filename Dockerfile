FROM ruby:2.3

RUN apt-get -y update && \
  apt-get -y install nodejs

WORKDIR /app
COPY Gemfile Gemfile.lock ./

RUN bundle install

# A minimal copy of what is neccessary to precompile assets.
# Prevents asset rebuild when all that's changed is model code.
COPY Rakefile ./
COPY vendor/assets ./vendor/assets/
COPY config/ ./config
COPY app/assets ./app/assets/

RUN bundle exec rake assets:precompile

COPY . ./

EXPOSE 3000
