module Voluntary
  module Api
    module V1
      class BaseController < ActionController::Base #ActionController::Metal
        #include ActionController::Rendering        # enables rendering
        #include ActionController::MimeResponds     # enables serving different content types like :xml or :json
        #include AbstractController::Callbacks      # callbacks for your authentication logic
        
        after_filter :set_access_control_headers
        
        def set_access_control_headers
          headers['Access-Control-Allow-Origin'] = '*'
          headers['Access-Control-Request-Method'] = '*'
        end
      end
    end
  end
end