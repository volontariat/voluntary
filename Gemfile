source "http://rubygems.org"

# Declare your gem's dependencies in voluntary.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

gem "rack-cors", "~> 0.2.4", :require => "rack/cors"
gem "thin", "~> 1.3.1", :require => false
gem "settingslogic", :git => "https://github.com/binarylogic/settingslogic.git"
gem "acts_as_markup", :git => "git://github.com/vigetlabs/acts_as_markup.git"
gem "auto_html", :git => "git://github.com/Applicat/auto_html"
gem "recaptcha", :require => "recaptcha/rails"
gem "sinatra", :require => false
gem "addressable", "~> 2.2", :require => "addressable/uri"
gem "jasmine", :git => "https://github.com/pivotal/jasmine-gem.git"

group :development do
  gem "linecache", "0.46", :platforms => :mri_18
  gem "capistrano", :require => false
  gem "capistrano_colors", :require => false
  gem "capistrano-ext", :require => false
  gem "yard", :require => false
end

group :test do
  gem "cucumber-rails", "1.3.0", :require => false
  gem "rspec-instafail", ">= 0.1.7", :require => false
  gem "webmock", "~> 1.7", :require => false
  gem "simplecov", :require => false
end

group :development, :test do
  #gem "debugger", :platforms => :mri_19
  gem "ruby-debug", :platforms => :mri_18
end

group :assets do
  gem "therubyracer", :platforms => :ruby
  gem "asset_sync", :require => nil
end

group :production do
  gem "fastercsv", "1.5.5", :require => false
  gem "rack-ssl", :require => "rack/ssl"
  gem "rack-rewrite", "~> 1.2.1", :require => false
  gem "rack-google-analytics", :require => "rack/google-analytics"
  gem "rack-piwik", :require => false
end