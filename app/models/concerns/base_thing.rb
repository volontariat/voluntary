module BaseThing
  extend ActiveSupport::Concern
  
  included do
    # find or create movies list
    class_attribute :list_instance
  
    #LIST_ID = list.id
  
    has_many :list_items, as: :thing, dependent: :destroy
    has_many :user_list_items, as: :thing
    has_many :users, through: :user_list_items
    
    attr_accessible :name
    
    validates :name, presence: true, uniqueness: true
    
    acts_as_list
    
    pusherable "#{Rails.env}_channel"
  end
  
  module ClassMethods
    def list
      #if self.to_s.constantize.const_defined?('LIST_ID') && LIST_ID.present?
      #  self.to_s.constantize.list_instance ||= List.find(LIST_ID)
      #end
      
      return self.to_s.constantize.list_instance if self.to_s.constantize.list_instance.present?
      
      attributes = {
        adjective: 'best', topic: self.to_s, scope: 'ever', thing_type: self.to_s,
        negative_adjective: 'worst'
      }
      
      self.to_s.constantize.list_instance = List.where(attributes).first
      
      unless self.to_s.constantize.list_instance.present?
        self.to_s.constantize.list_instance = List.create!(attributes)      
      end
      
      self.to_s.constantize.list_instance
    end
  end
  
  # custom associations
  def lists; List.where(thing_type: self.to_s); end
end