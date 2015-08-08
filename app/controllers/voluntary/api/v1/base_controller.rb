module Voluntary
  module Api
    module V1
      class BaseController < ActionController::Base #ActionController::Metal
        def require_api_key
          render status: 401, json: { error: 'You need to pass your API key for this request!' } if current_user.nil?
        end 
        
        protected
        
        def current_user
          @current_user ||= User.where(api_key: params[:api_key]).first
        end
      end
    end
  end
end