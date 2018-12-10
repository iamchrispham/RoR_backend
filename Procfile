web: bundle exec puma -p $PORT -C ./config/puma.rb
worker: bundle exec sidekiq -q notifications -q default -q mailers -c 10
log: tail -f log/development.log