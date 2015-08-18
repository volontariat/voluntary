module Voluntary
  module Api
    module V1
      class ArgumentsController < ActionController::Base
        include Voluntary::V1::BaseController
       
        respond_to :json
        
        def index
          options = {}
        
          arguments = Argument
          arguments = Argument.where(
            argumentable_type: params[:argumentable_type], argumentable_id: params[:argumentable_id]
          ) if params[:argumentable_id].present?
          options[:json] = arguments.paginate(page: params[:page], per_page: 10)
          
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
        
        def create
          raise CanCan::AccessDenied if current_user.blank?
          
          respond_to do |format|
            format.json { render json: Argument.create_with_topic(params[:argument]) }
          end
        end
      end
    end
  end
end