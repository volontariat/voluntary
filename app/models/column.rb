class Column
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug
  include ActiveModel::MassAssignmentSecurity
  
  include Model::MongoDb::Customizable
  
  belongs_to :story
  
  has_many :tasks, dependent: :destroy
  
  field :key, type: String
  field :text, type: String
  field :state, type: String
  
  attr_accessible :story_id, :key, :text
  
  private
  
  def cache_product_association
    self.product_id = story.project.product_id if story_id.present? && (story.project rescue nil)
  end
end