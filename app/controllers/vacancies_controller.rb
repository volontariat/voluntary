class VacanciesController < ApplicationController
  include Applicat::Mvc::Controller::Resource
  
  before_filter :find_vacancy
  
  load_and_authorize_resource
  
  before_filter :find_project, only: [:index, :new, :edit]
  
  respond_to :html, :js, :json
  
  def index
    @vacancies = @project ? @project.vacancies : Vacancy.all
  end
  
  def show
    @comments = @vacancy.comments
  end
  
  def new
    @vacancy = Vacancy.new
    
    @vacancy.project = @project if @project
  end
  
  def create
    @vacancy = Vacancy.new(params[:vacancy])
    
    if @vacancy.project.user_id == current_user.id
      @vacancy.do_open
    else
      @vacancy.author_id = current_user.id 
      @vacancy.recommend
    end
    
    if @vacancy.save
      redirect_to @vacancy, notice: t('general.form.successfully_created')
    else
      render :new
    end
  end
  
  def edit
    @vacancy = Vacancy.friendly.find(params[:id])
  end
  
  def update
    @vacancy = Vacancy.friendly.find(params[:id])
    
    if @vacancy.update_attributes(params[:vacancy])
      redirect_to @vacancy, notice: t('general.form.successfully_updated')
    else
      render :edit
    end
  end

  def destroy
    @vacancy = Vacancy.friendly.find(params[:id])
    @vacancy.destroy
    redirect_to vacancies_url, notice: t('general.form.destroyed')
  end
  
  def resource
    @vacancy
  end
  
  transition_actions Vacancy::EVENTS
  
  protected
  
  def before_my_state
    # e.g. set attributes of resource
  end
  
  private
  
  def find_vacancy
    return unless params[:id].present?
    
    @vacancy = Vacancy
    @vacancy = @vacancy.includes(:project, :candidatures, :comments) if action_name == 'show'
    @vacancy = @vacancy.friendly.find(params[:id])
  end
  
  def find_project
    @project = params[:project_id].present? ? Project.friendly.find(params[:project_id]) : nil
  end
end