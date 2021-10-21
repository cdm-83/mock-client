from ruby:2.7.4
RUN apt-get update -qq && apt-get install -y coreutils
WORKDIR /var/www/ruby/mock-client/
COPY ./mock-client/ /var/www/ruby/mock-client/
RUN gem install bundler
RUN bundle update --bundler
RUN bundle install
EXPOSE 3000


