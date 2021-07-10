# askdarcel-api [![Build Status](https://travis-ci.org/ShelterTechSF/askdarcel-api.svg?branch=master)](https://travis-ci.org/ShelterTechSF/askdarcel-api)

This project exposes the API endpoints for supporting the askdarcel-web project, which is built using a Ruby on Rails API Server


## Onboarding information

[Dev Role Description](https://www.notion.so/sheltertech/Developer-Engineer-Role-Description-ShelterTech-AskDarcel-SFServiceGuide-Tech-Team-7fd992a20f864698a43e3882a66338bb)

[Technical Onboarding & Team Guidelines](https://www.notion.so/sheltertech/Technical-Onboarding-and-Team-Guidelines-a06d5543495248bfb6f17e233330249e)


## Docker-based Development Environment (Recommended)

### Requirements

Docker Community Edition (CE) >= 17.06

Docker Compose >= 1.18

Download and install the version of [Docker for your OS](https://www.docker.com/community-edition#/download).


#### Creating the `.env` file

The `.env` file is a de facto file format that allows you to specify environment
variables that can be read by an application. It makes it easier to pass
environment variables to an application without manually having to set them in
the environment. It is supported by:
- [Docker](https://code.visualstudio.com/docs/python/environments) (built in)
- [NodeJS](https://www.npmjs.com/package/dotenv) (as a library)
- [Ruby](https://github.com/bkeepers/dotenv) (as a library)

In the root of the repo cloned to your local machine, create a file named `.env` with the credentials listed in [this
document](https://www.notion.so/sheltertech/API-Keys-Env-variables-3913e9074b61403c860d1a4649060e4f).


### Set up the project

This is not a full guide to Docker and Docker Compose, so please consult other
guides to learn more about those tools.

```sh
# Build (or rebuild) Docker images
$ docker-compose build

# Start the database container (in the background with -d)
$ docker-compose up -d db

# Generate random database fixtures
$ docker-compose run --rm api rake db:setup db:populate

# Start the Rails development server in the api container (in the foreground)
$ docker-compose up api

# Stop all containers, including background ones
$ docker-compose stop
```


### Running Postman tests from the command line

```sh
# Reset DB with initial database fixtures
$ docker-compose run --rm api rake db:setup db:populate

# Run Docker container that executes Postman CLI tool named newman
$ docker-compose run --rm postman
```


### Alternative database setup

```sh
# Populate the database with an old dump of the database (circa mid-2017)
$ docker-compose run --rm api rake db:create db:schema:load linksf:import

# Populate the database with a direct copy of the live staging database.
# - Ask technical team for the staging database password.
$ docker-compose run -e STAGING_DB_PASSWORD=<...> --rm api rake db:setup db:import_staging
```

### Developer Tools
#### Rails console
The [Rails console](https://guides.rubyonrails.org/command_line.html#rails-console) gives the developer access to the Rails application

Steps:
1. Navigate to the `askdarcel-api` directory
2. Start both the DB and API
3. Start the Rails console using the following command
```sh
$ docker-compose run --rm api rails console
```
4. Use the rails console

#### Byebug
[Byebug](https://github.com/deivid-rodriguez/byebug) allows for easy Ruby debugging

Steps:
1. Navigate to the `askdarcel-api` directory
2. Place `byebug` on a new line in the code you want to debug
2. Start both the DB and API
3. Attach a listener to the askdarcel-api docker container using the following command
    ```sh
    $ docker attach $(docker ps -aqf "name=askdarcel-api_api")
    ```
4. Use the app or postman to call the code of interest. The listener should pause the execution at the `byebug` statement
5. [Debug with byebug](https://www.sitepoint.com/the-ins-and-outs-of-debugging-ruby-with-byebug/)

## macOS-based Development Environment Not Using Docker

### Install Dependencies

1. [Install Homebrew](http://brew.sh/).
2. Install [rbenv](https://github.com/rbenv/rbenv) and [ruby-build](https://github.com/rbenv/ruby-build#readme).
  - `brew install rbenv`
    + Follow further setup instructions (including updating your bash
      profile) from the link above.
    + Add the following lines to your `~/.bash_profile`
    ```
    export PATH="$HOME/.rbenv/bin:$PATH"
    eval "$(rbenv init -)"
    ```
  - `brew install ruby-build`
3. Install postgres.
  - `brew install postgresql`
    + Follow further setup instructions displayed after installation.
  - `brew services start postgres`


### Set up the project

After cloning the repository and `cd`ing into the workspace:

1. Install the required ruby version.
  - `rbenv install`
2. Install the `bundle` gem if it isn't yet installed.
      - `which bundle || gem install bundle`
3. Install the required gems.
  - `bundle install`
  If encounter "command not found" error, run
  -`source ~/.bash_profile`

4. Set up the Algolia credentials
    - Create a .env file in the root of your askdarcel-api directory
    - Populate that file with the backend environment variables found [here](https://www.notion.so/sheltertech/API-Keys-Env-variables-3913e9074b61403c860d1a4649060e4f)

5. Set up the development database and load dummy data.
  - `rake db:create:all`
  - `rake db:migrate`
  - `rake linksf:import`

  Alternatively, you can generate random fixtures:
  - `rake db:setup db:populate`

6. (Optional) Run the background job worker.
  - To run a worker to continuously process background jobs:
    - `rake jobs:work`
  - To run a worker to process all existing background jobs and exit:
    - `rake jobs:workoff`

7. Run the development server.
  - `rails s -b 0.0.0.0`
8. Do NOT do sudo install -rails

