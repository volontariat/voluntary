class ArgumentSerializer < ActiveModel::Serializer
  attributes :id, :vote, :topic_id, :topic_name, :argumentable_type, :argumentable_id, :argumentable_name, :value, :user_id, :user_name, :user_slug

  def argumentable_name
    object.argumentable.try(:name)
  end
  
  def topic_name
    object.topic.try(:name)
  end
  
  def user_name
    object.user.try(:name)
  end
  
  def user_slug
    object.user.try(:slug)
  end
end