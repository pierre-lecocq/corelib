FROM ruby:2.4

# Install

RUN apt-get update && apt-get install -y --no-install-recommends libsasl2-dev

# ENV

ENV DB_HOST=corelib-database
ENV DB_USER=corelib
ENV DB_PASSWORD=corelib
ENV DB_DBNAME=corelib

ENV CACHE_HOST=corelib-cache
ENV CACHE_PORT=11211

ENV MAILER_METHOD=logger

ENV QUEUE_HOST=corelib-queue
ENV QUEUE_PORT=11300

ENV SEARCH_HOST=corelib-search

# Prepare

WORKDIR /code
COPY Gemfile .
RUN bundle check || bundle install

# Launch

CMD ["irb"]
