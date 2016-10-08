FROM ruby:2.1

# Create app directory
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

# Bundle app source
COPY . /usr/src/app

EXPOSE 3000

RUN bundle install
CMD [ "rails", "s" ]