class StorySerializer < ActiveModel::Serializer
  attributes :id, :name, :text, :product_id, :state
end