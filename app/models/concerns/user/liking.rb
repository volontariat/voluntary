class User
  module Liking
    extend ActiveSupport::Concern
            
    included do
      has_many :likes_or_dislikes, class_name: 'Like', dependent: :destroy
      has_many :likes, -> { where(positive: true) }, dependent: :destroy
      has_many :dislikes, -> { where(positive: false) }, class_name: 'Like', dependent: :destroy
    end
  end
end