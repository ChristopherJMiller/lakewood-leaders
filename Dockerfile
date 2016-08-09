FROM ruby:2.3

RUN apt-get update \
    && apt-get install -y --no-install-recommends mariadb-client

WORKDIR /usr/src/app
COPY Gemfile* ./
RUN bundle install
COPY . .
RUN RAILS_ENV=production rake db:create db:migrate
RUN rake assets:precompile

EXPOSE 3000
CMD ["unicorn", "-p", "3000", "-c", "./config/unicorn.rb"]
