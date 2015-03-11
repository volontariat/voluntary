module Voluntary
  module Api
    module V1
      class BaseController < ActionController::Base #ActionController::Metal
        #include ActionController::Rendering        # enables rendering
        #include ActionController::MimeResponds     # enables serving different content types like :xml or :json
        #include AbstractController::Callbacks      # callbacks for your authentication logic
      end
    end
  end
end