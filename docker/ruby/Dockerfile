FROM ruby:2.4

# Install

RUN apt-get update && apt-get install -y --no-install-recommends libsasl2-dev

# Prepare

WORKDIR /code
COPY Gemfile .
RUN bundle check || bundle install

# Launch

CMD ["irb"]
