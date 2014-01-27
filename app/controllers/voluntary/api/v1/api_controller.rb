module Voluntary
  module Api
    module V1
      class BaseController < ActionController::API
        include Voluntary::V1::BaseController
      end
    end
  end
end