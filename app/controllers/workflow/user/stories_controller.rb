class Workflow::User::StoriesController < ApplicationController
  def index
    @stories = Story.where(state: 'active', :users_without_tasks_ids.ne => current_user.id).paginate(page: params[:page], per_page: 20)
    projects = Project.where(id: @stories.map(&:project_id)).index_by(&:id)
    products = Product.where(id: projects.values.map(&:product_id)).index_by(&:id)
    
    @stories.map! do |story|
      projects[story.project_id].product = products[projects[story.project_id].product_id]
      story.project = projects[story.project_id]
      story
    end
    
    render layout: false if request.xhr?
  end
end