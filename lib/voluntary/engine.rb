module Voluntary
  class Engine < ::Rails::Engine
    config.autoload_paths << File.expand_path("../../../app/models/concerns", __FILE__)
    config.autoload_paths << File.expand_path("../../../app/controllers/concerns", __FILE__)
    config.autoload_paths << File.expand_path("../..", __FILE__)
    config.i18n.load_path += Dir[File.expand_path("../../../config/locales/**/*.{rb,yml}", __FILE__)]
    
    initializer "voluntary.add_middleware" do |config|
      config.middleware.insert_after Rack::Runtime, Rack::MethodOverride
      config.middleware.insert_after ActiveRecord::QueryCache, ActionDispatch::Cookies
      config.middleware.insert_after ActionDispatch::Cookies, ActionDispatch::Session::CookieStore
      config.middleware.insert_after ActionDispatch::Session::CookieStore, ActionDispatch::Flash
    end
  end
end
