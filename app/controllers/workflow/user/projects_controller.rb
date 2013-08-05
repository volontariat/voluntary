class Workflow::User::ProjectsController < ApplicationController
  def show
    @project = Project.find(params[:id])
    @stories = @project.stories.active.paginate(page: params[:page])
  end
end