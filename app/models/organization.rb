class Organization < ActiveRecord::Base
  include Applicat::Mvc::Model::Resource::Base
  #include Applicat::Mvc::Model::Tree
  include Applicat::Mvc::Model::Tokenable
  
  belongs_to :user
  
  has_many :projects
  
  validates :user_id, presence: true
  validates :name, presence: true, uniqueness: true
  
  attr_accessible :name
  
  extend FriendlyId
  
  friendly_id :name, :use => :slugged
  
  PARENT_TYPES = ['user']
end