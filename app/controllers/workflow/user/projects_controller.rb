class Workflow::User::ProjectsController < ApplicationController
  def show
    @project = Project.find(params[:id])
    
    @stories = @project.product.stories_for_user(current_user).
    where(project_id: @project.try(:id)).paginate(page: params[:page])
  end
end