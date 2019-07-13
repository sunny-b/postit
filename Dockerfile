FROM phusion/passenger-ruby23:0.9.33

ENV HOME /root

CMD ["/sbin/my_init"]

RUN apt-get -y update && \
  apt-get -y install nodejs

RUN rm -f /etc/service/nginx/down
RUN rm /etc/nginx/sites-enabled/default

RUN /bin/bash -l -c "rvm install 2.3.3"

ADD nginx/postit.conf /etc/nginx/sites-enabled/postit.conf
ADD nginx/rails-env.conf /etc/nginx/main.d/rails-env.conf:

WORKDIR /home/app/postit

COPY Gemfile* ./

ENV BUNDLE_GEMFILE=/home/app/postit/Gemfile \
  BUNDLE_JOBS=2 \
  BUNDLE_PATH=/bundle_cache

RUN bundle check || bundle install --without development test

# A minimal copy of what is neccessary to precompile assets.
# Prevents asset rebuild when all that's changed is model code.
COPY Rakefile ./
COPY vendor/assets ./vendor/assets/
COPY config/ ./config
COPY app/assets ./app/assets/

RUN bundle exec rake assets:precompile

COPY --chown=app:app . .

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
