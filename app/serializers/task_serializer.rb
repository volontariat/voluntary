class TaskSerializer < ActiveModel::Serializer
  attributes :id, :name, :text, :offeror_id, :author_id, :user_id
end