module Voluntary
  class Engine < ::Rails::Engine
    config.autoload_paths << File.expand_path("../../../app/models/concerns", __FILE__)
    config.autoload_paths << File.expand_path("../../../app/controllers/concerns", __FILE__)
    config.autoload_paths << File.expand_path("../..", __FILE__)
    config.i18n.load_path += Dir[File.expand_path("../../../config/locales/**/*.{rb,yml}", __FILE__)]
    config.active_record.observers ||= []
    
    [:candidature_observer, :story_observer, :task_observer].each do |observer|
      config.active_record.observers << observer
    end
  end
end
