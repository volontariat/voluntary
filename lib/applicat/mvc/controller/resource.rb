module Applicat::Mvc::Controller::Resource
  def self.included(base)
    base.class_eval do
      helper_method :parent, :resource
      
      include InstanceMethods
    end
  end
  
  module InstanceMethods
    def autocomplete
      render json: (
        params[:controller].classify.constantize.
        select(:name).order(:name).where("name LIKE ?", "%#{params[:term]}%").
        map(&:name)
      ), root: false
    end
  end
end