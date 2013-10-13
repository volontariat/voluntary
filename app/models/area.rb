class Area < ActiveRecord::Base
  include Applicat::Mvc::Model::Resource::Base
  include Applicat::Mvc::Model::Tree
  include Applicat::Mvc::Model::Tokenable
  
  has_and_belongs_to_many :users
  has_and_belongs_to_many :projects
  
  validates :name, presence: true, uniqueness: true
  
  attr_accessible :name, :parent_id
  
  extend FriendlyId
  
  friendly_id :name, :use => :slugged
  
  def self.find_by_product_id(product_id)
    roots.joins(:projects).merge(Project.for_product_id(product_id))
  end
  
  def children_for_product_id(product_id)
    children.joins(:projects).merge(Project.for_product_id(product_id))
  end
    
  def products
  end
end