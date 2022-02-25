FROM ruby:2.7.5-alpine3.15

ENV RAILS_ENV=production \
    NODE_ENV=production \
    RAILS_SERVE_STATIC_FILES=true \
    RAILS_LOG_TO_STDOUT=true \
    RACK_TIMEOUT_SERVICE_TIMEOUT=60 \
    BUNDLE_WITHOUT=development

RUN mkdir /app
WORKDIR /app

EXPOSE 3000
ENTRYPOINT ["bundle", "exec"]
CMD ["rails db:migrate && rails server"]

# hadolint ignore=DL3018
RUN apk add --no-cache build-base tzdata shared-mime-info git nodejs yarn postgresql-libs postgresql-dev

# security patch for apline3.15
# hadolint ignore=DL3019
RUN apk add --upgrade gmp=6.2.1-r1

# security patch for apline3.15-EXPAT
# hadolint ignore=DL3019
RUN apk add --upgrade expat=2.4.5-r0 


# install NPM packages removign artifacts
COPY package.json yarn.lock ./
RUN yarn install && yarn cache clean

# Install bundler
RUN gem install bundler --version=2.2.8

# Install Gems removing artifacts
COPY .ruby-version Gemfile Gemfile.lock ./
# hadolint ignore=SC2046
RUN bundle install --jobs=$(nproc --all) && \
    rm -rf /root/.bundle/cache && \
    rm -rf /usr/local/bundle/cache

# Add code and compile assets
COPY . .
RUN bundle exec rake assets:precompile

ARG APP_SHA
RUN echo "${APP_SHA}" > /etc/get-teacher-training-adviser-service-sha
