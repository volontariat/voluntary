module Voluntary
  module Api
    module V1
      class ArgumentTopicsController < ActionController::Base
        include Voluntary::V1::BaseController
       
        respond_to :json
        
        def autocomplete
          render json: (
            ArgumentTopic.order(:name).where("name LIKE ?", "%#{params[:term]}%").
            map{|t| { id: t.id, value: t.name }}
          ), root: false
        end
      end
    end
  end
end