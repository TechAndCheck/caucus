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
1. Run `rails db:migrate` to create the initial database

## Development
1. Make sure you have a locally running Postgres instance.
1. Install Redis and start it up in the background
1. In one terminal start up Webpacker's dev server `./bin/webpack-dev-server`
1. Run `rails s` in another terminal window to run the server itself.
1. Visit `localhost:3000` to make sure it's working
1. Create your first user in the Rails console by starting `rails c`
1. Create the user `u = User.create({name: "Test User", email: "test@example.com", password: "password123"})`
1. Assign the user as an admin `u.add_role :admin`
1. Save again `u.save!`
1. Exit the console and start the server with `rails s` again and go to `localhost:3000`
1. Log in with the user created above

### Optional Development Steps

#### Import From FactStream
Note: This should be a rake task really
1. Ensure that `FACT_STREAM_BASE_URI` in `application.yml` is properly set
1. Enter the Rails console `rails c`
1. Run `FactStreamClient.new.all_fact_checks(true)` in the console.

#### Suppress Ruby 2.7/Rails 6 Warnings
- Rails 6.0.x is not fully up on Ruby 2.7, so there's a bunch of errors. They don't hurt anything but do
  muck up the entire logs pretty badly. If you want to also suppress them in dev mode (you do), and use `rbenv` to manage your
  Ruby versions, you can install the `rbenv-vars` plugin, which will automatically apply the `.rbenv-vars`
  options to any Ruby commands in this folder.

  Install it by running `git clone https://github.com/rbenv/rbenv-vars.git $(rbenv root)/plugins/rbenv-vars`
  (or if you're using Fish `git clone https://github.com/rbenv/rbenv-vars.git (rbenv root)/plugins/rbenv-vars`).
  It should just work then.

## Notes
 - Uses https://bootswatch.com/journal/ for the theme


