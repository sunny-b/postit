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

COPY --chown=app:app . .

ARG environment=development
ARG db_user=root
ARG db_pass=sekret
ARG db_host=localhost
ARG secret_token

ENV RAILS_ENV=${environment}
ENV RACK_ENV=${environment}
ENV DB_USER=${db_user}
ENV DB_PASS=${db_pass}
ENV DB_HOST=${db_host}
ENV SECRET_TOKEN=${secret_token}

RUN bundle exec rake assets:precompile

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
