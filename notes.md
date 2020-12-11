Hey!

To get started evaluating this project, all you should need are Docker and Docker Compose.

If you are on macOS and use Homebrew, I believe you can run `brew install --cask docker` and it will get Docker Desktop installed as well as the CLI tools.

Else, please follow the Docker install instructions for your OS.

## Usage

### Docker

```shell
# setup
make setup

# run the automated test suite
make test

# run the server, will be available on port 4000
make server
```

### Local

If you want to run the app locally, you can install the required language version using `asdf` (https://asdf-vm.com).

```shell
# install languages
asdf install

# install postgres
brew install --cask postgres

# and yarn however you would do it
brew install yarn

# install deps
mix deps.get
(cd assets && yarn)

# create and migrate db
mix ecto.create
mix ecto.migrate

# run the server
mix phx.server

# install chrome and chromedriver
brew install --cask google-chrome chromedriver

# run the tests
mix test
```

## Description

This project implements a link shortening service written with Elixir/Phoenix, JS/React, TailwindCSS, and Postgres.

The test suite is composed of integration tests written with Wallaby and some controller tests to test the JSON API directly.

The frontend is styled using TailwindCSS, my preferred CSS library. It respects your user preferences, so it should show a light mode or dark mode based on your settings.
