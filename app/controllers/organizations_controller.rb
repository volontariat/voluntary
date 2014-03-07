class OrganizationsController < ApplicationController
  include Applicat::Mvc::Controller::Resource
  
  before_filter :find_organization
  
  load_and_authorize_resource
  
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  
  respond_to :html, :js, :json
  
  def index
    @parent = find_parent Organization::PARENT_TYPES
    @organizations = @parent ? @parent.organizations.order(:name) : Organization.order(:name)
    
    respond_to do |format|
      format.html
      format.json { render json: @organizations.tokens(params[:q]) }
    end
  end
  
  def show
  end
  
  def new
    @organization = Organization.new
  end
  
  def create
    @organization = current_user.organizations.new(params[:organization])
    
    if @organization.save
      redirect_to @organization, notice: t('general.form.successfully_created')
    else
      render :new
    end
  end
  
  def edit
  end
  
  def update
    if @organization.update_attributes(params[:organization])
      redirect_to @organization, notice: t('general.form.successfully_updated')
    else
      render :edit
    end
  end

  def destroy
    @organization.destroy
    redirect_to organizations_url, notice: t('general.form.destroyed')
  end
  
  def resource
    @organization
  end
  
  private
  
  def not_found
    redirect_to organizations_path, notice: t('organizations.exceptions.not_found')
  end
  
  def find_organization
    @organization = Organization.friendly.find(params[:id]) if params[:id].present?
  end
end