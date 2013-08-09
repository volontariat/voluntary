module Voluntary
  module Generators
    class ProductDummyGenerator < ::Rails::Generators::Base
      source_root File.expand_path("../templates", __FILE__)
  
      def copy_templates
        ['app', 'config', 'features', 'spec', 'vendor'].each do |directory_name|
          directory directory_name
        end
      end
      
      def gem_dependencies
        create_file 'Gemfile', ''
        
        add_source "http://rubygems.org"
        add_source "http://gems.github.com"
        
        # core
        gem 'bundler', '> 1.1.0'
        gem 'rack-cors', '~> 0.2.4', require: 'rack/cors'
        gem 'thin', '~> 1.3.1', require: false
        
        # model 
        gem 'settingslogic', git: 'https://github.com/binarylogic/settingslogic.git'
        
        # TODO: check if we need edge version
        #gem 'acts-as-taggable-on', git: 'https://github.com/mbleigh/acts-as-taggable-on.git'
        
        # view 
        gem 'acts_as_markup', git: 'git://github.com/vigetlabs/acts_as_markup.git'
        gem 'auto_html', git: 'git://github.com/Applicat/auto_html'
        gem 'recaptcha', require: 'recaptcha/rails'
        gem "will_paginate", github: "mislav/will_paginate"
        
        # queue
        
        gem 'sinatra', require: false
        
        # URIs and HTTP
        
        gem 'addressable', '~> 2.2', require: 'addressable/uri'
        
        # test
        
        gem 'jasmine', git: 'https://github.com/pivotal/jasmine-gem.git'
        
        # misc
        
        # invalid byte sequence in US-ASCII on production
        #  gem 'markerb', git: 'https://github.com/plataformatec/markerb.git'
        
        gem_group :development do
          gem 'linecache', '0.46', platforms: :mri_18
          gem 'capistrano', require: false
          gem 'capistrano_colors', require: false
          gem 'capistrano-ext', require: false
          gem 'yard', require: false
        end
        
        gem_group :test do
          gem 'cucumber-rails', '1.3.0', require: false
          gem 'rspec-instafail', '>= 0.1.7', require: false
          gem 'webmock', '~> 1.7', require: false
          gem 'simplecov', require: false
        end
        
        gem_group :development, :test do
          gem 'debugger', platforms: :mri_19
          gem 'ruby-debug', platforms: :mri_18
        end
        
        gem_group :assets do
          gem 'therubyracer', platforms: :ruby
          
          # asset_sync is required as needed by application.rb
          gem 'asset_sync', require: nil
        end
         
        gem_group :production do
          # dependency nokogiri is incompatible with cucumber-rails
          #  gem 'rails_admin', git: 'git://github.com/halida/rails_admin.git'
          gem 'fastercsv', '1.5.5', require: false
          gem 'rack-ssl', require: 'rack/ssl'
          gem 'rack-rewrite', '~> 1.2.1', require: false
          
          # analytics
          gem 'rack-google-analytics', require: 'rack/google-analytics'
          gem 'rack-piwik', require: 'rack/piwik', require: false
        end
      end
      
      def append_load_seed_data
        create_file 'db/seeds.rb' unless File.exists?(File.join(destination_root, 'db', 'seeds.rb'))
        append_file 'db/seeds.rb', :verbose => true do
          <<-EOH
delivery_method_was = ActionMailer::Base.delivery_method
ActionMailer::Base.delivery_method = :test

db_seed = VolontariatSeed.new
db_seed.create_fixtures

ActionMailer::Base.delivery_method = delivery_method_was
          EOH
        end
      end
    end
  end
end