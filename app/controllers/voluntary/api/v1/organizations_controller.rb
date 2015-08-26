module Voluntary
  module Api
    module V1
      class OrganizationsController < ActionController::Base
        include Voluntary::V1::BaseController
       
        respond_to :json
        
        def index
          options = {}
        
          collection = Organization.order('name')
          collection = collection.where(user_id: params[:user_id]) if params[:user_id].present?
          options[:json] = collection.paginate(page: params[:page], per_page: 100)
          
          options[:meta] = { 
            pagination: {
              total_pages: options[:json].total_pages, current_page: options[:json].current_page,
              previous_page: options[:json].previous_page, next_page: options[:json].next_page
            }
          }
          
          respond_with do |format|
            format.json { render options }
          end
        end
      end
    end
  end
end