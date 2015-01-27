module Likeable
  extend ActiveSupport::Concern
          
  included do
    belongs_to :target, polymorphic: true
    
    has_many :likes, -> { where(positive: true) }, dependent: :delete_all, as: :target
    has_many :likers, class_name: 'User', through: :likes, source: :user
    has_many :dislikes, -> { where(positive: false) }, class_name: 'Like', dependent: :delete_all, as: :target
    has_many :dislikers, class_name: 'User', through: :dislikes, source: :user
  end
  
  def update_likes_counter
    self.class.where(id: self.id).update_all likes_count: self.likes.count, dislikes_count: self.dislikes.count
  end
end