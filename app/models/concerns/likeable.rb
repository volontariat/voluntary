module Likeable
  extend ActiveSupport::Concern
          
  included do
    belongs_to :target, polymorphic: true
    
    has_many :likes, -> { where(positive: true) }, dependent: :delete_all, as: :target
    has_many :likers, class_name: 'User', through: :likes, source: :user
    has_many :dislikes, -> { where(positive: false) }, class_name: 'Like', dependent: :delete_all, as: :target
    has_many :dislikers, class_name: 'User', through: :dislikes, source: :user
    
    scope :liked_by, ->(user_id) do
      positive_likes_string = if ActiveRecord::Base.connection.instance_of?(ActiveRecord::ConnectionAdapters::PostgreSQLAdapter) 
        "likes.positive = 't'"
      else
        'likes.positive = 1'
      end
      
      select('music_videos.*, likes.created_at AS liked_at').joins("RIGHT JOIN likes ON #{positive_likes_string} AND likes.target_type = 'MusicVideo' AND likes.target_id = music_videos.id").
      where('likes.user_id = ? AND music_videos.id IS NOT NULL', user_id)
    end
  end
  
  def update_likes_counter
    self.class.where(id: self.id).update_all likes_count: self.likes.count, dislikes_count: self.dislikes.count
  end
  
  module ClassMethods
    def likes_or_dislikes_for(user, ids)
       user.likes_or_dislikes.for_targets(name, ids).index_by(&:target_id)
    end
  end
end