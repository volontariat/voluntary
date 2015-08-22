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
            format.json { render json: Argument.create_with_topic(current_user.id, params[:argument]) }
          end
        end
        
        def update
          resource = current_user.arguments.where('arguments.id = ?', params[:id]).first
          errors = {}
          
          if resource.nil?
            errors[:base] = I18n.t('activerecord.errors.models.general.attributes.base.user_resource_not_found')
          else
            topic = ArgumentTopic.find_or_create_by_name params[:argument][:topic_name]
            params[:argument][:topic_id] = topic.id
            resource.update_attributes params[:argument]
            resource.valid?
            errors = resource.errors.to_hash
          end
          
          respond_to do |format|
            format.json do
              render json: errors.empty? ? resource : { errors: errors }
            end
          end
        end
        
        def destroy
          resource = current_user.arguments.find params[:id]
          resource.destroy
          
          respond_to do |format|
            format.json do
              render json: if resource.persisted?
                { error: I18n.t('activerecord.errors.models.argument.attributes.base.deletion_failed') }
              else
                {}
              end
            end
          end
        end
      end
    end
  end
end