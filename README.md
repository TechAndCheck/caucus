# Caucus

Caucus is a system to tag/categorize sentences ("claims" in our original use case). It does it by making
it fun for users and annoyingly addictive.

## Setup

1. Duplicate `config/application.yml.example` and rename to `application.yml`
1. If you're using Heroku you'll need to set up non-volatile storage (and it's probably a good idea anyways).
   The default way is to use AWS S3, during which you'll have to create an IAM user, and put its credentials
   in the `config/application.yml` file. For development and test/CI purposes the local storage is fine.
1. You'll need a Redis server up and running. For development purposes look up instructions [here](https://redis.io/).
   This is used for ActiveStorage.
1. Set up Postgres, for local and test builds you can run it locally, for production feel free to set it up appropriately
   for your environment.
1. For the moment Mailgun is not necessary, leave the environment variable there though.

## Notes
 - Uses https://bootswatch.com/journal/ for the theme


