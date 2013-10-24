class Task
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug
  #include Mongoid::History::Trackable
  
  include Model::MongoDb::Customizable
  include Model::MongoDb::Commentable
  include StateMachines::Task
  
  belongs_to :story
  belongs_to :result, dependent: :destroy
  
  accepts_nested_attributes_for :result, allow_destroy: true
  
  field :offeror_id, type: Integer
  field :user_id, type: Integer
  field :author_id, type: Integer
  field :name, type: String
  field :text, type: String
  field :state, type: String
  field :unassigned_user_ids, type: Array
  
  slug :name, reserve: ['new', 'edit', 'next']
   
  attr_accessible :story, :story_id, :name, :text, :result_attributes
  
  scope :current, where(state: 'new')
  scope :unassigned, where(user_id: nil)
  scope :assigned, ne(user_id: nil)
  scope :complete, where(state: 'completed')
  scope :incomplete, ne(state: 'completed')
  
  validates :story_id, presence: true
  validates :offeror_id, presence: true
  validates :text, presence: true, if: ->(t) { t.class.name == 'Task' }
  validate :name_valid?
  
  after_initialize :cache_associations
  before_validation :cache_associations  
    
  #track_history on: [:user_id, :name, :text, :state]
    
  PARENT_TYPES = ['story']

  # belongs_to (SQL)
  def offeror; offeror_id ? User.find(offeror_id) : nil; end
  def offeror=(value); self.offeror_id = value.id; end
  
  def user; user_id ? User.find(user_id) : nil; end
  def user=(value); self.user_id = value.id; end
  
  def author; author_id ? User.find(author_id) : nil; end
  def author=(value); self.author_id = value.id; end
  
  def result_class
    if product_id.present?
      "#{product.class.name}::Result".constantize rescue Result
    else
      Result
    end
  end
  
  def with_result?
    true
  end
  
  def before_transition(transition)
    self.event = transition.event.to_s
    self.state_before = transition.from
    
    case transition.event
    when :assign
      self.author_id = self.user_id
    when :cancel
      self.unassigned_user_ids ||= []
      self.unassigned_user_ids << self.user_id
      self.user_id = nil
      self.author_id = nil
      self.result.text = nil if self.result
    when :review
      self.user_id = self.offeror_id
    when :follow_up
      self.user_id = self.author_id
    end
  end
  
  def after_transition(transition)
    case transition.event
    when :follow_up
      self.story.activate if self.story.completed?
    when :complete
      if self.story.tasks.complete.count == self.story.tasks.count
        self.story.complete
      end
    end
  end
  
  protected
  
  # validates :name, presence: true, uniqueness: { scope: :story_id }
  def name_valid?
    return unless name_changed?
    
    if name.present?
      if Task.where(name: name, story_id: story_id).any?
        errors.add(:name, I18n.t('errors.messages.taken'))
      end
    else
      errors.add(:name, I18n.t('errors.messages.blank'))
    end
  end
  
  private
  
  def cache_associations
    self.offeror_id = story.offeror_id if story_id.present? && (story rescue nil)
  end
  
  def cache_product_association
    self.product_id = story.product_id if story_id.present? && (story rescue nil)
  end
end