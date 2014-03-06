class CandidaturesController < ApplicationController
  include Applicat::Mvc::Controller::Resource
  
  before_filter :find_candidature, only: [:show, :edit, :update, :destroy]
  before_filter :find_vacancy, only: [:index, :new, :edit]
  
  load_and_authorize_resource
  
  transition_actions Candidature::EVENTS
  
  helper_method :parent
  
  respond_to :html, :js, :json
  
  def index
    @candidatures = if @vacancy
      @vacancy.candidatures.includes(:vacancy, :resource)
    else 
      Candidature.includes(:vacancy, :resource).where(resource_type: 'User').all
    end
  end
  
  def show
    @vacancy = @candidature.vacancy
    @comments = @candidature.comments
  end
  
  def new
    @candidature = Candidature.new
    @candidature.vacancy = parent
  end
  
  def create
    @candidature = Candidature.new(params[:candidature])
    @candidature.resource_type = 'User'
    @candidature.resource_id = current_user.id
    
    if @candidature.save
      redirect_to @candidature, notice: t('general.form.successfully_created')
    else
      render :new
    end
  end
  
  def edit
  end
  
  def update
    if @candidature.update_attributes(params[:candidature])
      redirect_to @candidature, notice: t('general.form.successfully_updated')
    else
      render :edit
    end
  end

  def destroy
    @candidature.destroy
    redirect_to candidatures_url, notice: t('general.form.destroyed')
  end
  
  def resource
    @candidature
  end
  
  def parent
    @vacancy
  end
  
  protected
  
  def set_twitter_sidenav_level
    @twitter_sidenav_level = 5
  end
  
  private
  
  def find_candidature
    @candidature = Candidature.includes(:vacancy, :resource, :comments).friendly.find(params[:id])
  end
  
  def find_vacancy
    @vacancy = params[:vacancy_id].present? ? Vacancy.friendly.find(params[:vacancy_id]) : nil
  end
end