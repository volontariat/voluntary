$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "voluntary/version"

# Describe your   s.add_dependency and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "voluntary"
  s.version     = Voluntary::VERSION
  s.authors     = ["Mathias Gawlista"]
  s.email       = ["gawlista@gmail.com"]
  s.homepage    = "http://github.com/Applicat/voluntary"
  s.summary     = "This is a gem which turns your rails application into a crowdsourcing platform to run on your intranet or on the internet."
  s.description = "This is a gem which turns your rails application into a crowdsourcing platform to run on your intranet or on the internet."

  s.files = Dir["{app,config,db,lib,vendor_extensions}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency 'rails', '~> 4.0.0'
 
  # rails 3
  s.add_dependency 'protected_attributes', '~> 1.0.5 '
  s.add_dependency 'activerecord-deprecated_finders', '~> 1.0.3'

  # misc
  s.add_dependency 'rubyzip', '~> 1.1.0'
  s.add_dependency 'zip-zip', '~> 0.2'
  
  # core
  s.add_dependency 'pg', '~> 0.17.1'
  s.add_dependency 'mongoid', '~> 4.0.0.alpha2'
  s.add_dependency 'foreman', '~> 0.46'
  s.add_dependency 'rails_autolink', '~> 1.1.5'
  s.add_dependency 'remotipart', '~> 1.0'
  s.add_dependency 'messagebus_ruby_api', '~> 1.0.3'
  
  # authentication / authorization
  s.add_dependency 'devise', '~> 3.2.2'
  s.add_dependency 'devise-encryptable', '~> 0.1.2'
  s.add_dependency 'cancan', '~> 1.6.10'
  s.add_dependency 'omniauth', '~> 1.2.2'
  s.add_dependency 'omniauth-facebook', '~> 2.0.0'
  s.add_dependency 'omniauth-google-oauth2', '~> 0.2.6'
  s.add_dependency 'omniauth-lastfm', '~> 0.0.6'
  
  # cannot load such file -- devise/schema (LoadError)
  #  s.add_dependency 'devise_rpx_connectable'

  # model 
  s.add_dependency 'foreigner', '~> 1.1.0'
  s.add_dependency 'ancestry', '~> 2.0.0'
  s.add_dependency 'state_machine', '~> 1.2.0'
  s.add_dependency 'acts_as_list', '~> 0.4.0'
  s.add_dependency 'activerecord-import', '~> 0.4.1'
  s.add_dependency 'koala', '~> 1.8.0'
  s.add_dependency 'ransack', '~> 1.1.0'
  s.add_dependency 'faker', '~> 1.2.0'# needed not just for testing but for rake db:seed, too
  s.add_dependency 'paper_trail', '~> 3.0.0'
  s.add_dependency 'mongoid-history', '~> 0.4.1'
  s.add_dependency 'acts-as-taggable-on', '~> 2.4.1'

  # mongo model
  s.add_dependency 'mongoid_slug', '~> 3.2.0'

  # controller
  s.add_dependency 'has_scope', '~> 0.5.1'
  
  s.add_dependency 'friendly_id', '~> 5.0.0' # use 4.x for Rails 3 and later 5.x for Rails 4
  s.add_dependency 'wicked', '~> 1.0.2'
  s.add_dependency 'rails-api', '~> 0.2.0'
  s.add_dependency 'versionist', '~> 1.2.1'

  # view
  s.add_dependency 'simple-navigation', '~> 3.11.0'  
  s.add_dependency 'facebox-rails', '~> 0.2.0'
  s.add_dependency 'simple_form', '~> 3.0.0'
  s.add_dependency 'country_select', '~> 1.3.1'
  s.add_dependency 'diffy', '~> 3.0.1'
  s.add_dependency 'font-awesome-rails', '~> 4.0.3.1'
  s.add_dependency 'bootstrap-sass-rails', '~> 2'
  s.add_dependency 'auto_html', '~> 1.6.4'
  
  # Could not find a valid   s.add_dependency 'mobile_fu' (>= 0) in any repository
  #  s.add_dependency 'mobile-fu'

  # 3.0.5 from 3-0-stable branch currently drops mongoid support that's why 3.0.4
  s.add_dependency 'will_paginate', '~> 3.0.4'
  s.add_dependency 'gon', '~> 5.0.1'
  
  # javascript
  s.add_dependency 'selectize-rails', '~> 0.12.0'
  s.add_dependency 'jquery-rails'
  s.add_dependency 'jquery-ui-bootstrap-rails-asset'
  s.add_dependency 'bootstrap-datetimepicker-rails', '~> 0.0.11'
  
  # file uploading

  s.add_dependency 'carrierwave', '~> 0.6.2'
  s.add_dependency 'fog', '~> 1.19.0'
  s.add_dependency 'mini_magick', '~> 3.4'

  # JSON and API

  s.add_dependency 'json', '~> 1.8.1'
  s.add_dependency 'acts_as_api', '~> 0.4.2'

  # localization

  s.add_dependency 'i18n-inflector-rails', '~> 1.0'
  s.add_dependency 'rails-i18n', '~> 4.0.1'

  # queue

  #  s.add_dependency 'resque', '1.20.0'
  #  s.add_dependency 'resque-timeout', '1.0.0'
  s.add_dependency 'sidekiq', '~> 2.17.3'
  s.add_dependency 'slim', '~> 2.0.2'

  # URIs and HTTP

  s.add_dependency 'http_accept_language', '~> 1.0.2'
  s.add_dependency 'typhoeus', '~> 0.5.3'
  s.add_dependency 'capistrano', '~> 2.15.5'

  # includes jquery 1.11.0 which is not supported by ember.js
  #s.add_dependency 'jquery-rails', '~> 3.1.0'
  s.add_dependency 'jquery-rails', '2.2.2'
  s.add_dependency 'jquery-ui-bootstrap-rails-asset', '~> 0.0.3'
  s.add_dependency 'bootstrap-sass-rails', '~> 2.3.2.1'
  
  # TODO: get rid of exception wrong number of arguments (3 for 2) for form_for
  #s.add_dependency 'client_side_validations', '~> 3.2.6'
  
  # ffi dependency older than the one from selenium-webdriver
  #  s.add_dependency 'pygments.rb'

  #s.add_dependency 'twitter-bootstrap-rails', '2.1.3'
  s.add_dependency 'simple-navigation-bootstrap', '~> 1.0.0'

  # web

  s.add_dependency 'faraday', '~> 0.8.9'
  s.add_dependency 'faraday_middleware', '~> 0.9.0'
  
  # group :development
  s.add_development_dependency 'letter_opener', '~> 1.0.0'

  # for tracing AR object instantiation and memory usage per request
  s.add_development_dependency 'oink', '~> 0.10.1'

  # group :development, :test
  s.add_development_dependency 'awesome_print', '~> 1.1.0'
  s.add_development_dependency 'rspec-rails', '~> 2.0' 
  
  # group :test
  s.add_development_dependency 'capybara', '~> 1.1.2'
  s.add_development_dependency 'capybara-webkit', '~> 0.13.0'
  s.add_development_dependency 'cucumber', '~> 1.2.5'
  s.add_development_dependency 'cucumber-rails-training-wheels', '~> 1.0.0'
  s.add_development_dependency 'timecop', '~> 0.6.1'
  s.add_development_dependency 'factory_girl_rails', '~> 1.7.0'
  s.add_development_dependency 'fixture_builder', '~> 0.3.3'
  s.add_development_dependency 'selenium-webdriver', '~> 2.22.1'
  s.add_development_dependency 'spork', '~> 1.0rc2'
  s.add_development_dependency 'guard-rspec', '~> 3.0.2'
  s.add_development_dependency 'guard-spork', '~> 1.5.1'
  s.add_development_dependency 'guard-cucumber', '~> 1.4.0'
  s.add_development_dependency 'launchy', '~> 2.1.2'

  # group :cucumber, :test
  s.add_development_dependency 'database_cleaner', '~> 0.7.1'

  # Gems used only for assets and not required  
  # in production environments by default.
  # group :assets
  s.add_dependency 'sass-rails',     '~> 4.0.5'
  s.add_dependency 'coffee-rails',   '~> 4.0.0'
  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  s.add_dependency 'handlebars_assets', '~> 0.15'
  s.add_dependency 'uglifier', '~> 2.4.0'
  s.add_dependency 'coffee-script', '~> 2.2.0'
end
