class ArgumentTopic < ActiveRecord::Base
  has_many :arguments
  
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  
  attr_accessible :name, :text
end