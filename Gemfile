source "https://rubygems.org"

gem 'sinatra'
gem 'thin'
gem 'json'
gem 'sequel'
gem 'rbnacl-libsodium'
gem 'tux'
gem 'hirb'
gem 'config_env'

group :development do
  gem 'rerun'
end

group :test do
  gem 'minitest'
  gem 'rack'
  gem 'rack-test'
  gem 'rake'
end

group :development, :test do
  gem 'sqlite3'
end

group :production do
  gem 'pg'
end
