# Caucus

Caucus is a system to tag/categorize sentences ("claims" in our original use case). It does it by making
it fun for users and annoyingly addictive.

## Requirements

- [Redis](https://redis.io/)
- [PostgreSQL](https://www.postgresql.org/)
- Ruby 2.7
- Rails 6
- Yarn for js management

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
1. Make sure you're running Ruby 2.7. I like to use [rbenv](https://github.com/rbenv/rbenv) to manage the Ruby versions.
1. Install the gems `bundle install`
1. Install javascript requirements `yarn install`

## Development
1. Make sure you have a locally running Postgres instance.
1. Install Redis and start it up in the background
1. In one terminal start up Webpacker's dev server `./bin/webpack-dev-server`
1. Run `rails s` in another terminal window to run the server itself.
1. Visit `localhost:3000` to make sure it's working
1. Create your first user in the Rails console by starting `rails c`
1. Create the user `u = User.create({name: "Test User", email: "test@example.com", password: "password123"})`
1. Assign the user as an admin `u.assign_role :admin`
1. Save again `u.save!`
1. Exit the console and start the server with `rails s` again and go to `localhost:3000`
1. Log in with the user created above

## Notes
 - Uses https://bootswatch.com/journal/ for the theme


