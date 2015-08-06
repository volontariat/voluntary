module Voluntary
  module Api
    module V1
      class TasksController < Voluntary::Api::V1::BaseController
        respond_to :json
        
        def index
          params[:page] = nil if params[:page] == ''
          params[:per_page] = nil if params[:per_page] == ''
          collection = Task.where(story_id: params[:story_id])
          collection = collection.where(state: params[:state]) if params[:state].present?
          collection = collection.paginate(per_page: params[:per_page] || 50, page: params[:page] || 1)
          
          respond_to do |format|
            format.json {
              render json: {
                current_page: collection.current_page, per_page: collection.per_page, 
                total_entries: collection.total_entries, total_pages: collection.total_pages,
                entries: collection.map(&:to_json),
              }.to_json
            }
          end
        end
      end
    end
  end
end