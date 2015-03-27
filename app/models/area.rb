class Area < ActiveRecord::Base
  include Applicat::Mvc::Model::Resource::Base
  include Applicat::Mvc::Model::Tree
  include Applicat::Mvc::Model::Tokenable
  
  has_and_belongs_to_many :users
  has_and_belongs_to_many :projects
  
  scope :with_projects_for_product, ->(product_id) do
    select('DISTINCT(areas.id), areas.*').joins(%Q{
      LEFT JOIN areas areas2 ON areas2.id = areas.id OR areas2.ancestry like CONCAT(areas.id, '/', '%') 
        OR areas2.ancestry like CONCAT('%', '/', areas.id) 
        OR areas2.ancestry like CONCAT('%', '/', areas.id, '/', '%')  
        OR areas2.ancestry = CONCAT(areas.id, '') 
      LEFT JOIN areas_projects ON areas_projects.area_id = areas2.id 
      LEFT JOIN projects ON projects.id = areas_projects.project_id
    }).where('areas2.id IS NOT NULL AND projects.product_id = ?', product_id)
  end
  
  validates :name, presence: true, uniqueness: true
  
  attr_accessible :name, :parent_id
  
  extend FriendlyId
  
  friendly_id :name, :use => :slugged
  
  def self.find_by_product_id(product_id)
    #roots.joins(:projects).merge(Project.for_product_id(product_id))
    roots.with_projects_for_product(product_id)
  end
  
  def children_for_product_id(product_id)
    #children.joins(:projects).merge(Project.for_product_id(product_id))
    children.with_projects_for_product(product_id)
  end
    
  def products
  end
end