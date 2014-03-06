class Voluntary::ApplicationController < ActionController::Base
  include Applicat::Mvc::Controller
  include Voluntary::V1::BaseController
  
  protect_from_forgery
  
  before_filter :set_twitter_sidenav_level
  
  layout Proc.new { |controller| controller.request.xhr? ? 'facebox' : 'application' }
  
  respond_to :html, :js, :json
  
  protected

  def after_sign_in_path_for(resource_or_scope)
    if resource_or_scope.main_role.is_a? Role::ProjectOwner
      workflow_project_owner_index_path
    elsif resource_or_scope.main_role.is_a? Role::User
      workflow_user_index_path
    else
      workflow_path
    end
  end
  
  def set_twitter_sidenav_level
    @twitter_sidenav_level = 3
  end
  
  def response_with_standard(format = nil, error = nil)
    render status: error ? 500 : 200, json: { success: error ? false : true, error: error} and return true
  end
end
