class Profession < ActiveRecord::Base
  include Applicat::Mvc::Model::Resource::Base
  
  has_many :users
  
  validates :name, presence: true, uniqueness: true
  
  attr_accessible :name
  
  extend FriendlyId
  
  friendly_id :name, :use => :slugged
  
  private
  
  def should_generate_new_friendly_id?
    slug.blank? || name_changed?
  end
end