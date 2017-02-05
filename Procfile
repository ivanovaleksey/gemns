web: bundle exec rackup config.ru -p $PORT
worker: bundle exec sidekiq -r ./lib/gemsy.rb -c 5
