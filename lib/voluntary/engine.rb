module Voluntary
  class Engine < ::Rails::Engine
    config.autoload_paths << File.expand_path("../../../app/models/concerns", __FILE__)
    config.autoload_paths << File.expand_path("../../../app/controllers/concerns", __FILE__)
    config.autoload_paths << File.expand_path("../..", __FILE__)
    config.i18n.load_path += Dir[File.expand_path("../../../config/locales/**/*.{rb,yml}", __FILE__)]
    
    config.generators do |g|
      g.orm :active_record
    end
    
    initializer "voluntary.add_middleware" do |config|
      config.middleware.insert_after Rack::Runtime, Rack::MethodOverride
      config.middleware.insert_after ActiveRecord::QueryCache, ActionDispatch::Cookies
      config.middleware.insert_after ActionDispatch::Cookies, ActionDispatch::Session::CookieStore
      config.middleware.insert_after ActionDispatch::Session::CookieStore, ActionDispatch::Flash
    end
    
    initializer "voluntary.add_view_helpers" do |config|
      ActionView::Base.send :include, Voluntary::ApplicationHelper
      ActionView::Base.send :include, Voluntary::CollectionHelper
      ActionView::Base.send :include, Voluntary::CommentsHelper
      ActionView::Base.send :include, Voluntary::FormHelper
      ActionView::Base.send :include, Voluntary::LanguageHelper
      ActionView::Base.send :include, Voluntary::LayoutHelper
      ActionView::Base.send :include, Voluntary::ProductHelper
      ActionView::Base.send :include, Voluntary::ShowHelper
      ActionView::Base.send :include, Voluntary::WizardHelper
    end
  end
end
