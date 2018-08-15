FROM ruby:2.5.1

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

RUN apt-get update && \
    apt-get install -y mysql-client imagemagick unzip \
                    fonts-vlgothic \
                    --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

ADD Gemfile /usr/src/app/
ADD Gemfile.lock /usr/src/app/
RUN bundle install --system

ADD . /usr/src/app

EXPOSE 3000

CMD bin/start_server.sh
