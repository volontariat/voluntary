class Workflow::User::ProjectsController < ApplicationController
  def show
    @project = Project.friendly.find(params[:id])
    
    product = if @project.product 
      @project.product
    else
      value = ::Product.new
      value.id = 'no-name'
      value
    end
    
    @stories = product.stories_for_user(current_user).
    where(project_id: @project.try(:id)).paginate(page: params[:page])
  end
end