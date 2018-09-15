RailsBootstrap
===============

[![Build Status](https://travis-ci.org/Grupo-TDP2/api-tp-sistema-de-inscripciones.svg?branch=master)](https://travis-ci.org/Grupo-TDP2/api-tp-sistema-de-inscripciones)
[![Test Coverage](https://api.codeclimate.com/v1/badges/a82725fb6b5a67978601/test_coverage)](https://codeclimate.com/github/Grupo-TDP2/api-tp-sistema-de-inscripciones/test_coverage)
Kickoff for Rails web applications.

## Running local server

### Git pre push hook

You can modify the [pre-push.sh](script/pre-push.sh) script to run different scripts before you `git push` (e.g Rspec, Linters). Then you need to run the following:

```bash
  chmod +x script/pre-push.sh
  sudo ln -s ../../script/pre-push.sh .git/hooks/pre-push
```

You can skip the hook by adding `--no-verify` to your `git push`.

### 1- Installing Ruby

- Clone the repository by running `git clone git@github.com:Grupo-TDP2/api-tp-sistema-de-inscripciones.git`
- Go to the project root by running `cd api-tp-sistema-de-inscripciones`
- Download and install [Rbenv](https://github.com/rbenv/rbenv#basic-github-checkout).
- Download and install [Ruby-Build](https://github.com/rbenv/ruby-build#installing-as-an-rbenv-plugin-recommended).
- Install the appropriate Ruby version by running `rbenv install [version]` where `version` is the one located in [.ruby-version](.ruby-version)

### 2- Installing Yarn

```bash
  curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
  sudo apt remove cmdtest # Some Ubuntu systems comes with cmdtest installed by default.
  sudo apt-get update && sudo apt-get install yarn
```

### 3- Installing Rails gems

- Install [Bundler](http://bundler.io/).

```bash
  gem install bundler --no-ri --no-rdoc
  rbenv rehash
```
- Install basic dependencies if you are using Ubuntu:

```bash
  sudo apt-get install build-essential libpq-dev nodejs
```

- Install all the gems included in the project.

```bash
  bundle install
```

### [Kickoff] Application Setup

Your app is ready. Happy coding!

### Database Setup

Run in terminal:

```bash
  sudo -u postgres psql
  CREATE ROLE "api-tp-sistema-de-inscripciones" LOGIN CREATEDB PASSWORD 'api-tp-sistema-de-inscripciones';
```

Log out from postgres and run:

```bash
  bundle exec rake db:create db:migrate
```

Your server is ready to run. You can do this by executing `rails server` and going to [http://localhost:3000](http://localhost:3000). Happy coding!

#### Using React In Views

Install react dependencies running:

```bash
  ./script/react
```

## Deploy Guide

#### Heroku

If you want to deploy your app using [Heroku](https://www.heroku.com) you need to do the following:

- Add the Heroku Git URL to your remotes

```bash
  git remote add heroku-prod your-git-url
```

- Configure the Heroku build packs and specify an order to run the npm-related steps first

```bash
  heroku buildpacks:clear
  heroku buildpacks:set heroku/nodejs
  heroku buildpacks:add heroku/ruby --index 2
```

- Push to Heroku

```bash
	git push heroku-prod your-branch:master
```

## Code Climate

Add your code climate token to [.travis.yml](.travis.yml#L7) or [docker-compose.yml](docker-compose.yml)

## Dotenv

We use [dotenv](https://github.com/bkeepers/dotenv) to set up our environment variables in combination with `secrets.yml`.

For example, you could have the following `secrets.yml`:

```yml
production: &production
  foo: <%= ENV['FOO'] %>
  bar: <%= ENV['BAR'] %>
```

and a `.env` file in the project root that looks like this:

```
FOO=1
BAR=2
```

When you load up your application, `Rails.application.secrets.foo` will equal `ENV['FOO']`, making your environment variables reachable across your Rails app.
The `.env` will be ignored by `git` so it won't be pushed into the repository, thus keeping your tokens and passwords safe.
