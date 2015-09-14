class StoriesController < ApplicationController
  include Applicat::Mvc::Controller::Resource
  include Wizard::Controller
  
  wizard_steps :initialization, :setup_tasks, :activate
  
  before_filter :build_resource, only: [:new, :create]
  before_filter :resource, only: [:show, :edit, :update, :setup_tasks, :activate]
  
  load_and_authorize_resource
  
  respond_to :html, :js, :json
  
  def index
    parent = find_parent Story::PARENT_TYPES
    @stories = parent ? parent.stories : Story.all
  end
  
  def show
    @comments = @story.comments
  end
  
  def new
    render_wizard
  end
  
  def create
    if @story.initialization
      redirect_to edit_story_path(@story) and return
    else
      render_wizard
    end
  end
  
  def edit
    render_wizard
  end
  
  def update
    @story.attributes = params[:story]
    success = params[:next_step] == '1' ? @story.send(step) : @story.save
    
    if success
      redirect_to(
        edit_story_path(@story), notice: t('general.form.successfully_updated')
      )
    else
      render_wizard
    end
    
    return
  end

  def destroy
    @story = Story.find(params[:id])
    @story.destroy
    redirect_to @story.project, notice: t('general.form.destroyed')
  end
  
  def resource
    @story = Story.find(params[:id]) unless @story || !params[:id].present?
    @project = @story.project unless @project || !@story
    @story
  end
  
  def resource=(value); @story = value; end
  
  def parent
    @project
  end
  
  protected
  
  def after_setup_tasks; render_wizard; end
  def after_activate; render_wizard; end
  
  private
  
  def build_resource
    @project = find_parent Story::PARENT_TYPES, action_name == 'create' ? :story : nil
    @story = @project.story_class.new({ project_id: @project.id }.merge(params[:story] || {}))
  end
  
  def render_wizard
    @presenter = Resources::General::Wizards::StoryPresenter.new(
      self.view_context, resource: resource
    )

    begin
      raise NotImplementedError if @project.product_id.blank?
      
      render "products/types/#{@project.product.class.name.split('Product::').last.tableize.singularize}/wizard"
    rescue NotImplementedError, ActionView::MissingTemplate
      render 'general/wizard'
    end
  end
end