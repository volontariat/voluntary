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
  
  def products
  end
end