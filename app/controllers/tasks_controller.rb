class TasksController < ApplicationController
  include Applicat::Mvc::Controller::Resource
  
  before_filter :build_resource, only: [:new, :create]
  before_filter :resource, only: [:show, :edit, :update, :destroy]
  
  load_and_authorize_resource
  
  respond_to :html, :js, :json
  
  def index
    @story = Story.find(params[:story_id])
    @project = @story.project
    @tasks = @story.custom_tasks
    @tasks = @tasks.paginate(page: params[:page], per_page: 25)
    @twitter_sidenav_level = 5
  end
  
  def show
    @hide_sidebar = true
    
    begin
      raise NotImplementedError if @project.product_id.blank?
      
      render "products/types/#{@project.product.class.name.split('Product::').last.tableize.singularize}/tasks/show"
    rescue NotImplementedError, ActionView::MissingTemplate
      render 'show'
    end
  end
  
  def new
  end
  
  def create
    if @task.save
      redirect_to story_tasks_path(@story), notice: t('tasks.create.successful')
    else
      render 'new'
    end
  end
  
  def edit
  end
  
  def update
    if @task.update(params[:task])
      redirect_to(
        edit_task_path(@task), notice: t('tasks.update.successful')
      )
    end
  end

  def destroy
    @task.destroy
    redirect_to story_tasks_path(@story), notice: t('general.form.destroyed')
  end
  
  def resource
    @task = Task.find(params[:id]) unless @task || !params[:id].present?
    @story = @task.story unless @story || !@task
    @project = @story.project
    @task
  end
  
  def resource=(value); @task = value; end
  
  def parent
    @story
  end
  
  private
  
  def build_resource
    @story = find_parent Task::PARENT_TYPES, action_name == 'create' ? :task : nil
    @project = @story.project
    @task = @story.tasks.new({ story_id: @story.id }.merge(params[:task] || {}))
  end
end