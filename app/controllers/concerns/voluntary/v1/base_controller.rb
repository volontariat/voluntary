module Voluntary
  module V1
    module BaseController
      extend ActiveSupport::Concern
      
      included do
        rescue_from CanCan::AccessDenied, with: :access_denied
        rescue_from ActiveRecord::RecordNotFound, with: :not_found
        rescue_from Mongoid::Errors::DocumentNotFound, with: :not_found
        
        helper_method :parent, :application_navigation, :navigation_product_path, :navigation_product_name, :voluntary_application_stylesheets
        helper_method :voluntary_application_javascripts
      end
      
      def voluntary_application_stylesheets
        ['voluntary/application', 'application'] 
      end
    
      def voluntary_application_javascripts
        ['voluntary/application', 'application'] 
      end
          
      def parent
        @parent
      end
      
      protected
      
      def application_navigation
        :main
      end
      
      def navigation_product_path
        '/'
      end
      
      def navigation_product_name
        'Core'
      end
      
      def current_ability
        Ability.new(current_user, controller_namespace: current_namespace)
      end
      
      def find_parent(types, parent_key = nil)
        parent_type, id = nil, nil
        
        if parent_type = types.select{|p| params.keys.include?("#{p}_id") }.first
          id = params["#{parent_type}_id"]
        elsif parent_type = types.select{|p| params[parent_key] && params[parent_key].keys.include?("#{p}_id") }.first
          id = params[parent_key]["#{parent_type}_id"]
        end
        
        return if parent_type.blank?
        
        parent = parent_type.classify.constantize
        parent = parent.friendly if parent.respond_to? :friendly
        parent = parent.find(id)
        
        root_model_class_name = Voluntary::ApplicationHelper.root_model_class_name_helper(parent)
        eval("@#{root_model_class_name.tableize.singularize} = parent") 
        
        parent
      end
      
      def response_with_standard(format = nil, error = nil)
        render status: error ? 500 : 200, json: { success: error ? false : true, error: error} and return true
      end
      
      private
      
      def current_namespace
        controller_name_segments = params[:controller].split('/')
        controller_name_segments.pop
        controller_namespace = controller_name_segments.join('/').downcase
      end
      
      def access_denied
        message = I18n.t('general.exceptions.access_denied')
        
        if request.format.try('json?') || request.xhr?
          render status: 403, json: { error: message } and return
        else
          flash[:alert] = message
          
          if request.env["HTTP_REFERER"]
            redirect_to :back
          else
            redirect_to root_path
          end
        end
      end
      
      def not_found(e)
        if Rails.env.development?
          raise e
        else
          logger.info "not found (#{e.inspect})"
          redirect_to root_path, notice: t('general.exceptions.not_found')
        end
      end
    end
  end
end