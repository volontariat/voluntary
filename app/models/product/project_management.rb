module Product::ProjectManagement
  extend ActiveSupport::Concern 
  
  included do
    has_many :stories, dependent: :nullify
  end
  
  module ClassMethods
    def stories(id, user)
      collection = if id == 'no-name'
        Story.exists(_type: false)
      else
        product = Product.find(id)
        
        begin
          product.story_class.for_user(user)
        rescue NotImplementedError
          product.story_class
        end
      end
      
      collection.where(:users_without_tasks_ids.ne => user.id)
    end
  end
    
  def projects; Project.where(product_id: id); end
  
  def story_class; "#{self.class.name}::Story".constantize rescue Story; end
end