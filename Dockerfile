from ruby
COPY ./mock-client/ /var/www/ruby
WORKDIR /var/www/ruby/mock-client/
CMD ["puma"]

