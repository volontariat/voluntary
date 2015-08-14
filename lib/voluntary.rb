require 'protected_attributes'
require 'active_record/deprecated_finders'
require 'rack/cors'
require 'pg'
require 'mongoid'
require 'foreman'
require 'rails_autolink'
require 'remotipart'
require 'messagebus_ruby_api'
require 'devise'
require 'omniauth'
require 'omniauth-facebook'
require 'omniauth-google-oauth2'
require 'omniauth-lastfm'
require 'cancan'
require 'foreigner'
require 'ancestry'
require 'state_machine'
require 'acts_as_list'
require 'activerecord-import'
require 'koala'
require 'faker'
require 'paper_trail'
require 'mongoid/history'
require 'mongoid_slug'
require 'has_scope'
require 'friendly_id'
require 'simple-navigation'  
require 'facebox-rails'
require 'simple_form'
require 'country_select'
require 'diffy'
require 'will_paginate'
require 'will_paginate_mongoid'
require 'gon'
require 'json'
require 'i18n-inflector-rails'
require 'rails-i18n'
require 'slim'
require 'http_accept_language'
require 'typhoeus'
require 'jquery-rails'
require 'bootstrap-sass-rails'
require 'bootstrap-datetimepicker-rails'
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
require 'thor'
require 'selectize-rails'
require 'bitmask_attributes'
require 'csv'
require 'httparty'

require 'voluntary/navigation'

if Rails.env == 'test'
  require 'voluntary/test/rspec_helpers/factories'
end

require 'voluntary/engine'

module Voluntary
end
