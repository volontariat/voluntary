class Workflow::User::TasksController < ApplicationController
  before_action :authenticate_user!
  
  def assigned
    @tasks = Task.includes(:story).where(user_id: current_user.id, state: 'assigned')
    projects = Project.where(id: @tasks.map{|t| t.story.project_id }).index_by(&:id)
    products = Product.where(id: projects.values.map(&:product_id)).index_by(&:id)
    
    @tasks.map! do |task|
      project = projects[task.story.project_id]
      project.product = products[project.product_id]
      task.story.project = project
      task
    end
    
    render layout: false if request.xhr?
  end
end