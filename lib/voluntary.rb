# controller
require 'rails-api'

# misc
require 'pg'
require 'mongoid'
require 'foreman'
require 'rails_autolink'
require 'remotipart'
require 'messagebus_ruby_api'
require 'devise'
require 'omniauth'
require 'omniauth-facebook'
require 'omniauth-tumblr'
require 'cancan'
require 'foreigner'
require 'ancestry'
require 'state_machine'
require 'acts_as_list'
require 'activerecord-import'
require 'koala'
require 'ransack' 
require 'faker'
require 'paper_trail'
require 'mongoid-history'
require 'mongoid_slug'
require 'has_scope'
require 'friendly_id'
require 'wicked'
require 'simple-navigation'  
require 'facebox-rails'
require 'simple_form'
require 'country_select'
require 'diffy'
require 'will_paginate'
require 'will_paginate/mongoid'
require 'gon'
require 'carrierwave'
require 'fog'
require 'mini_magick'
require 'json'
require 'acts_as_api'
require 'i18n-inflector-rails'
require 'rails-i18n'
require 'sidekiq'
require 'slim'
require 'http_accept_language'
require 'typhoeus'
require 'capistrano'
require 'jquery-rails'
require 'bootstrap-sass-rails'
require 'jquery-ui-bootstrap-rails-asset'
require 'auto_html'
#require 'twitter-bootstrap-rails'
require 'simple-navigation-bootstrap'
require 'faraday'
require 'faraday_middleware'
require 'sass-rails'
require 'sass'
require 'coffee-rails'
require 'handlebars_assets'
require 'uglifier'
require 'coffee-script'
require 'font-awesome-rails'

require 'voluntary/navigation'
require 'voluntary/helpers/application'
require 'voluntary/helpers/collection'
require 'voluntary/helpers/comments'
require 'voluntary/helpers/form'
require 'voluntary/helpers/language'
require 'voluntary/helpers/layout'
require 'voluntary/helpers/product'
require 'voluntary/helpers/show'
require 'voluntary/helpers/wizard'

require 'db_seed'
require 'volontariat_seed'

if Rails.env == 'test'
  require 'voluntary/test/rspec_helpers/factories'
end

require 'voluntary/engine'

module Voluntary
end

if defined?(ActionView::Base)
  ActionView::Base.send :include, Voluntary::Helpers::Application
  ActionView::Base.send :include, Voluntary::Helpers::Collection
  ActionView::Base.send :include, Voluntary::Helpers::Comments
  ActionView::Base.send :include, Voluntary::Helpers::Form
  ActionView::Base.send :include, Voluntary::Helpers::Language
  ActionView::Base.send :include, Voluntary::Helpers::Layout
  ActionView::Base.send :include, Voluntary::Helpers::Product
  ActionView::Base.send :include, Voluntary::Helpers::Show
  ActionView::Base.send :include, Voluntary::Helpers::Wizard
end
