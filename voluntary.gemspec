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

  s.add_dependency 'rails', '~> 3.2.13'

  # core
  s.add_dependency 'pg'
  s.add_dependency 'mongoid', '~> 3.0.0'
  s.add_dependency 'foreman', '0.46'
  s.add_dependency 'rails_autolink'
  s.add_dependency 'remotipart', '~> 1.0'
  s.add_dependency 'messagebus_ruby_api', '1.0.3'
  
  # authentication / authorization

  s.add_dependency 'devise'
  s.add_dependency 'cancan'
  s.add_dependency 'omniauth', '1.0.3'
  s.add_dependency 'omniauth-facebook'
  s.add_dependency 'omniauth-tumblr'
  
  # cannot load such file -- devise/schema (LoadError)
  #  s.add_dependency 'devise_rpx_connectable'

  # model 
  s.add_dependency 'foreigner', '~> 1.1.0'
  s.add_dependency 'ancestry'
  s.add_dependency 'state_machine'
  s.add_dependency 'acts_as_list'
  s.add_dependency 'activerecord-import'
  s.add_dependency 'koala'
  s.add_dependency 'ransack'
  s.add_dependency 'faker' # needed not just for testing but for rake db:seed, too
  s.add_dependency 'paper_trail'
  s.add_dependency 'mongoid-history'
  s.add_dependency 'acts-as-taggable-on', '2.4.1'

  # mongo model
  s.add_dependency 'mongoid_slug'

  # controller
  s.add_dependency 'has_scope'
  
  s.add_dependency 'friendly_id', '~> 4.0.0' # use 4.x for Rails 3 and later 5.x for Rails 4
  s.add_dependency 'wicked'

  # view
  s.add_dependency 'simple-navigation'  
  s.add_dependency 'facebox-rails'
  s.add_dependency 'simple_form'
  s.add_dependency 'country_select'
  s.add_dependency 'diffy'

  # Could not find a valid   s.add_dependency 'mobile_fu' (>= 0) in any repository
  #  s.add_dependency 'mobile-fu'

  s.add_dependency 'will_paginate'
  s.add_dependency 'client_side_validations'
  s.add_dependency 'gon'

  # file uploading

  s.add_dependency 'carrierwave', '0.6.2'
  s.add_dependency 'fog'
  s.add_dependency 'mini_magick', '3.4'

  # JSON and API

  s.add_dependency 'json'
  s.add_dependency 'acts_as_api'

  # localization

  s.add_dependency 'i18n-inflector-rails', '~> 1.0'
  s.add_dependency 'rails-i18n'

  # queue

  #  s.add_dependency 'resque', '1.20.0'
  #  s.add_dependency 'resque-timeout', '1.0.0'
  s.add_dependency 'sidekiq'
  s.add_dependency 'slim'

  # URIs and HTTP

  s.add_dependency 'http_accept_language', '~> 1.0.2'
  s.add_dependency 'typhoeus'
  s.add_dependency 'capistrano'

  # view
  s.add_dependency 'jquery-rails'
  s.add_dependency 'jquery-ui-bootstrap-rails-asset'
  s.add_dependency 'auto_html'
  
  # ffi dependency older than the one from selenium-webdriver
  #  s.add_dependency 'pygments.rb'

  #s.add_dependency 'twitter-bootstrap-rails', '2.1.3'
  s.add_dependency 'simple-navigation-bootstrap'

  # web

  s.add_dependency 'faraday'
  s.add_dependency 'faraday_middleware'
  
  # group :development
  s.add_development_dependency 'letter_opener'

  # for tracing AR object instantiation and memory usage per request
  s.add_development_dependency 'oink'

  # group :development, :test
  s.add_development_dependency 'awesome_print'
  s.add_development_dependency 'rspec-rails', '~> 2.0' 
  
  # group :test
  s.add_development_dependency 'capybara', '~> 1.1.2'
  s.add_development_dependency 'capybara-webkit'
  s.add_development_dependency 'cucumber-rails', '1.3.0'
  s.add_development_dependency 'cucumber-rails-training-wheels'
  s.add_development_dependency 'timecop'
  s.add_development_dependency 'factory_girl_rails', '1.7.0'
  s.add_development_dependency 'fixture_builder', '0.3.3'
  s.add_development_dependency 'fuubar', '>= 1.0'
  s.add_development_dependency 'selenium-webdriver', '~> 2.22.1'
  s.add_development_dependency 'spork', '~> 1.0rc2'
  s.add_development_dependency 'guard-rspec'
  s.add_development_dependency 'guard-spork'
  s.add_development_dependency 'guard-cucumber'
  s.add_development_dependency 'launchy'

  # group :cucumber, :test
  s.add_development_dependency 'database_cleaner', '0.7.1'

  # Gems used only for assets and not required  
  # in production environments by default.
  # group :assets
  s.add_dependency 'sass-rails',     '~> 3.2.3'
  s.add_dependency 'coffee-rails',   '~> 3.2.1'
  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  s.add_dependency 'handlebars_assets'
  s.add_dependency 'uglifier', '>= 1.0.3'
  s.add_dependency 'coffee-script'
end
