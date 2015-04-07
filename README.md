# Voluntary [![Build Status](https://travis-ci.org/volontariat/voluntary.svg?branch=master)](https://travis-ci.org/volontariat/voluntary) [![Code Climate](https://codeclimate.com/github/volontariat/voluntary/badges/gpa.svg)](https://codeclimate.com/github/volontariat/voluntary) [![Test Coverage](https://codeclimate.com/github/volontariat/voluntary/badges/coverage.svg)](https://codeclimate.com/github/volontariat/voluntary)

This is a gem which turns your rails application into a crowdsourcing platform to run on your intranet or on the internet.

Then you can add existing voluntary products like text creation or create your own products.

## Installation

### New Application

Run this in your console:

```bash
  rvm --create use 1.9.3@your_crowdsourcing_platform_name
  gem update bundler
  gem install rails -v 4.0.13 --no-rdoc --no-ri  
  rails new your_crowdsourcing_platform_name
  cd your_crowdsourcing_platform_name
```

Add this to your Gemfile:

```ruby
  gem 'voluntary'
```
  
Add voluntary products to your Gemfile.  
  
Run this in your console:

```bash
  bundle install  
```
  
Run this in your console (confirm all overwrite questions):

```bash
  rails g voluntary:install
  rake railties:install:migrations
```

Remove gem 'sqlite3' from your Gemfile.

Copy the content of config/database.example.yml into config/database.yml

Add this to your application.rb:

```ruby
  config.generators do |g|
    g.orm :active_record
  end
```

Remove public/index.html

Add at least 1 controller with 1 action, 1 view and a root route.

Add a Capfile to your Rails root.

Run this in your console:

```bash
  bundle install
  rake db:create
  rake db:migrate
  rake db:seed
  rails s
```

### New Product

```bash  
  git clone https://github.com/user/voluntary_product_name.git
  cd voluntary_product_name
  rvm --create use --rvmrc 1.9.3@voluntary_product_name # if you use RVM
  gem update bundler
  gem install rails -v 4.0.13 --no-ri --no-rdoc
  cd ..
  rails plugin new voluntary_product_name --database=postgresql --skip-javascript --skip-test-unit --dummy-path=dummy --full
  cd voluntary_product_name
  # Add voluntary gem as a dependency to gemspec ('~> 0.2.1').
  # Add development dependencies from the following gemspec to product's gemspec: https://github.com/volontariat/voluntary/blob/master/voluntary.gemspec
  # add "require 'voluntary'" to lib/voluntary_product_name.rb
  # bundle install
  cd dummy
  # Add development dependencies to dummy Gemfile, see voluntary_text_creation. 
  bundle install
  # change config/boot.rb to require bundler like here: https://github.com/volontariat/voluntary_scholarship/blob/master/dummy/config/boot.rb
  # change database names to #{product_name}_#{environment} and customize user credentials in config/database.yml
  bundle exec rake db:create:all && bundle exec rails g voluntary:product_dummy # confirm all overwrite questions except of Gemfile
  cd ..
  # add gitignore file from voluntary: https://github.com/volontariat/voluntary/blob/master/.gitignore
  rails g migration add_product_name_product
  # fill migration file with template: https://github.com/volontariat/voluntary_scholarship/blob/master/db/migrate/20140306201232_add_scholarship_product.rb
  cd dummy
  bundle exec rake railties:install:migrations
  # change database names to #{product_name}_#{environment} and customize user credentials in dummy/config/mongoid.yml
  bundle exec rake db:migrate && bundle exec rake db:test:clone_structure
  # create a class for your new product under app/models/product/product_name.rb like: https://github.com/volontariat/voluntary_scholarship/blob/master/app/models/product/scholarship.rb
  bundle exec rails s
```
  
## License 

This project uses MIT-LICENSE.
