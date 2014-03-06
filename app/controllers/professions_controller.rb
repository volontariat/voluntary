class ProfessionsController < ApplicationController
  include Applicat::Mvc::Controller::Resource
  
  before_filter :find_profession
  
  load_and_authorize_resource
  
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  
  respond_to :html, :js, :json
  
  def index
    @professions = Profession.order(:name)
      
    respond_to do |format|
      format.html
      format.json { render json: @professions.tokens(params[:q]) }
    end
  end
  
  def show
  end
  
  def new
    @profession = Profession.new
  end
  
  def create
    @profession = Profession.new(params[:profession])
    
    if @profession.save
      redirect_to @profession, notice: t('general.form.successfully_created')
    else
      render :new
    end
  end
  
  def edit
  end
  
  def update
    if @profession.update_attributes(params[:profession])
      redirect_to @profession, notice: t('general.form.successfully_updated')
    else
      render :edit
    end
  end

  def destroy
    @profession.destroy
    redirect_to professions_url, notice: t('general.form.destroyed')
  end
  
  def resource
    @profession
  end
  
  private
  
  def not_found
    redirect_to professions_path, notice: t('professions.exceptions.not_found')
  end
  
  def find_profession
    @profession = Profession.friendly.find(params[:id]) if params[:id].present?
  end
end