class Argument < ActiveRecord::Base
  include Likeable
   
  belongs_to :user
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
 
  attr_accessible :topic_id, :argumentable_type, :argumentable_id, :vote, :value
  
  attr_accessor :positive
  
  def self.create_with_topic(user_id, attributes)
    topic = ArgumentTopic.find_or_create_by_name attributes[:topic_name]
    
    if topic.valid?
      argumentable_id = if attributes[:argumentable_name].present?
        attributes[:argumentable_type].constantize.where('LOWER(name) = ?', attributes[:argumentable_name].downcase).first.id
      else
        attributes[:argumentable_type].constantize.where(id: attributes[:argumentable_id]).first.try(:id)
      end
      
      argument = Argument.new(
        topic_id: topic.id, argumentable_type: attributes[:argumentable_type], argumentable_id: argumentable_id, 
        value: attributes[:value], vote: attributes[:vote]
      )
      argument.user_id = user_id
      argument.save
      
      if argument.valid?
        argument
      else
        { errors: argument.errors.to_hash }
      end
    else
      { errors: { topic: topic.errors.to_hash } }
    end
  end
  
  def self.matrix(argumentables)
    arguments = []
    
    argumentables.each do |index, argumentable|
      arguments += Argument.where(
        argumentable_type: argumentable['type'], argumentable_id: argumentable['id']
      ).includes(:topic).to_a
    end
    
    arguments_by_name = {}
    
    arguments.each do |argument| 
      arguments_by_name[argument.topic.name] ||= []
      arguments_by_name[argument.topic.name] << argument
    end
    
    json = { argumentables: [], matrix: [] }
    
    argumentables.keys.map(&:to_i).sort.each do |argumentable_index|
      argumentable = argumentables[argumentable_index.to_s]
      argumentable = argumentable['type'].constantize.find(argumentable['id'])
      
      json[:argumentables] << { id: argumentable.id, slug: argumentable.try(:slug), name: argumentable.name }
    end
    
    arguments_by_name.keys.sort.each do |topic_name|
      item = { topic_name: topic_name, values: [] }
      arguments = arguments_by_name[topic_name]
      
      argumentables.keys.map(&:to_i).sort.each do |argumentable_index|
        argumentable = argumentables[argumentable_index.to_s]
        item[:values] << arguments.select{|a| a.argumentable_type == argumentable['type'] && a.argumentable_id == argumentable['id'].to_i }.first.try(:value)
      end
      
      json[:matrix] << item
    end
    
    json
  end
end