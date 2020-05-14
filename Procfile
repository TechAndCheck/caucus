release: rails db:migrate
web: bundle exec puma -C config/puma.rb
sidekiq: bundle exec sidekiq -c 5 -v
