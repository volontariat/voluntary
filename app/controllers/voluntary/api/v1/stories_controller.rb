class Voluntary::Api::V1::StoriesController < ActionController::Base
  include Voluntary::V1::BaseController
  
  respond_to :json
  
  def show
    story = Story.find(params[:id])
    
    respond_to do |format|
      format.json do
        render json: product_serializer('Story', story)
      end
    end
  end
  
  def create
    project = Project.find(params[:story][:project_id])
    story = project.story_class.new({ project_id: project.id }.merge(params[:story] || {}))
    
    authorize! :create, story
    
    story.save
    
    respond_to do |format|
      format.json do
        render json: story.persisted? ? product_serializer('Story', story) : { errors: story.errors.to_hash }
      end
    end
  end
  
  def update
    story = Story.find params[:id]
    
    authorize! :update, story
    
    story.update_attributes params[:story]
    
    respond_to do |format|
      format.json do
        render json: story.valid? ? product_serializer('Story', story) : { errors: story.errors.to_hash }
      end
    end
  end
  
  def destroy
    story = current_user.stories.friendly.find params[:id]
    
    authorize! :destroy, story
    
    story.destroy
    
    respond_to do |format|
      format.json do
        render json: if story.persisted?
          { error: I18n.t('activerecord.errors.models.story.attributes.base.deletion_failed') }
        else
          {}
        end
      end
    end
  end
end