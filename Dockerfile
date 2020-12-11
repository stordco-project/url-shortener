FROM elixir:1.11.2-alpine AS builder

# install build dependencies
RUN apk add --no-cache build-base yarn git bash chromium chromium-chromedriver

# prepare build dir
WORKDIR /app

# install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# set build ENV
ENV MIX_ENV=prod

# install mix dependencies
COPY mix.exs mix.lock .env .env.test ./
COPY config config
RUN mix do deps.get, deps.compile

# build assets
COPY lib lib
COPY assets/package.json assets/yarn.lock ./assets/
RUN cd assets && yarn install &&  cd ..

COPY priv priv
COPY assets assets
ENV NODE_ENV=production
RUN cd assets && yarn run deploy && cd ..
RUN mix phx.digest

# compile and build release
# uncomment COPY if rel/ exists
# COPY rel rel
RUN mix do compile, release

# prepare release image
FROM alpine:3.9 AS app
RUN apk add --no-cache openssl ncurses-libs bash chromium chromium-chromedriverh

WORKDIR /app

RUN chown nobody:nobody /app

USER nobody:nobody

COPY --from=builder --chown=nobody:nobody /app/_build/prod/rel/url_shortener ./

ENV HOME=/app

EXPOSE 4000

CMD ["bin/url_shortener", "start"]

