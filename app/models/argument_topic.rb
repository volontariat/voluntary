class ArgumentTopic < ActiveRecord::Base
  has_many :arguments
  
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  
  attr_accessible :name, :text
  
  def self.find_or_create_by_name(name)
    resource = where('LOWER(name) = ?', name.to_s.strip.downcase).first
    
    if resource
      resource
    else
      resource = create(name: name.to_s.strip)
    end
  end
end