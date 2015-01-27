class Like < ActiveRecord::Base
  belongs_to :user
  belongs_to :target, polymorphic: true
  
  scope :for_targets, ->(type, ids) do
    where('target_type = :type AND target_id IN(:ids)', type: type, ids: ids)
  end
  
  validates :target_id, presence: true, uniqueness: { scope: [:target_type, :user_id] }
  validates :target_type, presence: true
  validates :user_id, presence: true
  
  attr_accessible :positive, :target_id, :target_type
  
  after_save do
    self.target.update_likes_counter
  end

  after_destroy do
    self.target.update_likes_counter
  end
end