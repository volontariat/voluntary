module Voluntary
  module Api
    module V1
      class BaseController < ActionController::Base
        rescue_from CanCan::AccessDenied, with: :access_denied
        rescue_from ActiveRecord::RecordNotFound, with: :not_found
        rescue_from Mongoid::Errors::DocumentNotFound, with: :not_found
        
        def require_api_key
          render status: 401, json: { error: 'You need to pass your API key for this request!' } if current_user.nil?
        end 
        
        protected
        
        def current_user
          @current_user ||= User.where(api_key: params[:api_key]).first
        end
        
        private
        
        def access_denied
          render status: 401, json: { error: 'You are not authorized for this request!' }
        end
        
        def not_found
          render status: 403, json: { error: 'Record not found! ' + [current_user.id, Story.first].inspect }
        end
      end
    end
  end
end