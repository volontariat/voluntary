class Argument < ActiveRecord::Base
  belongs_to :topic, class_name: 'ArgumentTopic'
  belongs_to :argumentable, polymorphic: true
  
  scope :compare_two_argumentables, ->(argumentable_type, side, left_argumentable_name, right_argumentable_name) do
    left_argumentable_name, right_argumentable_name = right_argumentable_name, left_argumentable_name if side == 'right'
      
    left_argumentable = argumentable_type.constantize.where('LOWER(name) = ?', left_argumentable_name.downcase).first
    right_argumentable = argumentable_type.constantize.where('LOWER(name) = ?', right_argumentable_name.downcase).first
    
    scope = joins(:topic).select('arguments.id, arguments.value, arguments.topic_id, argument_topics.name AS topic_name, arguments2.id AS right_id, arguments2.value AS right_value').
    joins(
      "#{side == 'both' ? 'INNER' : 'LEFT'} JOIN arguments arguments2 ON " +
      "arguments2.argumentable_type = #{sanitize(argumentable_type)} AND " +
      "arguments2.argumentable_id = #{sanitize(right_argumentable.id)} AND arguments2.topic_id = arguments.topic_id"
    )
    scope = scope.where('arguments2.id IS NULL') unless side == 'both'
    scope.where('arguments.argumentable_type = ? AND arguments.argumentable_id = ?', argumentable_type, left_argumentable.id)
  end
  
  validates :topic_id, presence: true
  validates :argumentable_type, presence: true
  validates :argumentable_id, presence: true, uniqueness: { scope: [:topic_id, :argumentable_type] }
  validates :value, presence: true
  
  attr_accessible :topic_id, :argumentable_type, :argumentable_id, :value
  
  def self.create_with_topic(attributes)
    topic = ArgumentTopic.where('LOWER(name) = ?', attributes[:topic_name].to_s.strip.downcase).first
    
    unless topic
      topic = ArgumentTopic.create(name: attributes[:topic_name].to_s.strip)
    end
    
    if topic.valid?
      argumentable_id = if attributes[:argumentable_name].present?
        attributes[:argumentable_type].constantize.where('LOWER(name) = ?', attributes[:argumentable_name].downcase).first.id
      else
        attributes[:argumentable_type].constantize.where(id: attributes[:argumentable_id]).first.try(:id)
      end
      
      argument = Argument.create(
        topic_id: topic.id, argumentable_type: attributes[:argumentable_type], argumentable_id: argumentable_id, value: attributes[:value]
      )
      
      if argument.valid?
        argument
      else
        { errors: argument.errors.to_hash }
      end
    else
      { errors: { topic: topic.errors.to_hash } }
    end
  end
end