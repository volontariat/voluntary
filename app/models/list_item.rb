class ListItem < ActiveRecord::Base
  include BaseListItem
  
  attr_accessible :list_id, :thing, :thing_type, :thing_id, :best, :stars
  
  has_many :user_list_items, dependent: :destroy
  
  validates :thing_id, presence: true, uniqueness: { scope: [:list_id, :thing_type] }
  validate :type_equals_thing_type_of_list
  
  acts_as_list scope: :list
  
  private
  
  def type_equals_thing_type_of_list
    return unless list_thing_type = list.try(:thing_type)

    unless list_thing_type == thing_type
      errors[:thing_type] << I18n.t('activerecord.errors.models.list_item.attributes.thing_type.no_valid_type_for_list') 
    end
  end
end