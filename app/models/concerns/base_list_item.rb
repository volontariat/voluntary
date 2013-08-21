module BaseListItem
  extend ActiveSupport::Concern
  
  included do
    belongs_to :list
    belongs_to :thing, polymorphic: true
    
    validates :list_id, presence: true
    validates :thing_type, presence: true
    validates :thing_id, presence: true
    
    pusherable "#{Rails.env}_channel"
    
    def thing=(thing)
      thing.save if thing.new_record?
      
      self.thing_type = thing.class.name; self.thing_id = thing.id
      
      if self.respond_to?(:list_item_id) && self.list.present?
        self.list_item ||= self.list.items.find_or_create_by_thing_type_and_thing_id(thing_type, thing_id)
      end
      
      thing
    end
  end
end