class ProjectsController < ApplicationController
  include Applicat::Mvc::Controller::Resource
  
  before_filter :find_project
  
  load_and_authorize_resource
  
  respond_to :html, :js, :json
  
  def index
    @parent = find_parent Project::PARENT_TYPES
    @projects = @parent ? @parent.projects.order(:name) : Project.order(:name)
  end
  
  def show
    @project = Project.includes(:areas, :comments).friendly.find(params[:id])
    @comments = @project.comments
  end
  
  def new
    @parent = find_parent Project::PARENT_TYPES
    @project = @parent ? @parent.projects.new : Project.new
  end
  
  def create
    @project = Project.new(params[:project])
    @project.user_id = current_user.id
    
    if @project.save
      redirect_to @project, notice: t('general.form.successfully_created')
    else
      render :new
    end
  end
  
  def edit
  end
  
  def update
    if @project.update_attributes(params[:project])
      redirect_to @project, notice: t('general.form.successfully_updated')
    else
      render :edit
    end
  end

  def destroy
    @project.destroy
    redirect_to projects_url, notice: t('general.form.destroyed')
  end
  
  def resource
    @project
  end
  
  private
  
  def find_project
    @project = Project.friendly.find(params[:id]) if params[:id].present?
  end
end