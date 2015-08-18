class ArgumentSerializer < ActiveModel::Serializer
  attributes :id, :topic_id, :topic_name, :argumentable_type, :argumentable_id, :argumentable_name, :value

  def argumentable_name
    object.argumentable.try(:name)
  end
  
  def topic_name
    object.topic.try(:name)
  end
end