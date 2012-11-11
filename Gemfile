source "http://rubygems.org"

# Declare your gem's dependencies in voluntary.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

# core
gem 'rack-cors', '~> 0.2.4', require: 'rack/cors'
gem 'thin', '~> 1.3.1', require: false

# model 
gem 'settingslogic', git: 'https://github.com/binarylogic/settingslogic.git'
gem 'acts-as-taggable-on', git: 'https://github.com/mbleigh/acts-as-taggable-on.git'

# view 
gem 'acts_as_markup', git: 'git://github.com/vigetlabs/acts_as_markup.git'
gem 'auto_html', git: 'git://github.com/Applicat/auto_html'
gem 'recaptcha', require: 'recaptcha/rails'

# queue

gem 'sinatra', require: false

# URIs and HTTP

gem 'addressable', '~> 2.2', require: 'addressable/uri'

# test

gem 'jasmine', git: 'https://github.com/pivotal/jasmine-gem.git'

# misc

# invalid byte sequence in US-ASCII on production
#  gem 'markerb', git: 'https://github.com/plataformatec/markerb.git'

# group :development
gem 'linecache', '0.46', platforms: :mri_18
gem 'capistrano', require: false
gem 'capistrano_colors', require: false
gem 'capistrano-ext', require: false
gem 'yard', require: false

# group :test
gem 'cucumber-rails', '1.3.0', require: false
gem 'rspec-instafail', '>= 0.1.7', require: false
gem 'webmock', '~> 1.7', require: false
gem 'simplecov', require: false

# group :development, :test
gem 'debugger', platforms: :mri_19
gem 'ruby-debug', platforms: :mri_18

# group :assets
gem 'therubyracer', platforms: :ruby

# group :production
# dependency nokogiri is incompatible with cucumber-rails
#  gem 'rails_admin', git: 'git://github.com/halida/rails_admin.git'
gem 'fastercsv', '1.5.5', require: false
gem 'rack-ssl', require: 'rack/ssl'
gem 'rack-rewrite', '~> 1.2.1', require: false

# analytics
gem 'rack-google-analytics', require: 'rack/google-analytics'
gem 'rack-piwik', require: 'rack/piwik', require: false

# asset_sync is required as needed by application.rb
gem 'asset_sync', require: nil