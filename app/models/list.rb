class List < ActiveRecord::Base
  attr_accessible :adjective, :topic, :scope, :thing_type, :negative_adjective
  
  has_many :items, class_name: 'ListItem', dependent: :destroy
  
  validates :adjective, presence: true
  validates :topic, presence: true, uniqueness: { scope: [:adjective, :scope] }
  validates :scope, presence: true
  
  #pusherable "#{Rails.env}_channel"
  
  def self.find_or_create_by_params(params)
    attributes = (params[:user_list_item] || params[:list_item] || params).clone
    attributes.symbolize_keys! unless params.is_a?(ActiveSupport::HashWithIndifferentAccess)
    
    if attributes[:list_id].present? then List.find(attributes[:list_id])
    elsif attributes[:adjective].present?
      list  = List.new
      
      attributes.each {|param, value| attributes.delete(param) unless list.respond_to?(param) }
      
      List.where(attributes).first || List.create(attributes)
    elsif attributes[:topic].present?
      begin 
        attributes[:topic].classify.constantize.list
      rescue NameError
      end
    end
  end
end