release: rails db:migrate
web: bundle exec puma -C config/puma.rb
sidekiq: bundle exec sidekiq -e production -t 3600 -v
