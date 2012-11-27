class Product
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :_id, type: String, default: -> { name.to_s.parameterize }
  field :user_id, type: Integer
  field :name, type: String, localize: true
  field :klass_name, type: String
  field :text, type: String, localize: true
  field :area_ids, type: Array, default: []
  field :state, type: String
  
  attr_accessible :name, :text, :area_ids
  
  validates :name, presence: true, uniqueness: true
  
  validate :english_name_available?
  validate :existing_model_file?
  
  index({ name: 1 }, { unique: true })
  
  before_validation :set_klass_name
  
  # active record compatibility
  # just belongs_to reflections for cucumber's factory steps
  def self.reflections
    struct = OpenStruct.new(values: [])
    
    # sql belongs_to relations
    struct.values << OpenStruct.new(name: 'user', options: {})
    
    ::Product.relations.each do |relation_name, relation|
      # select only belongs_to relations
      next unless relation_name == relation_name.singularize
      
      # automatically include mongo db's belongs_to relations
      struct.values << OpenStruct.new(name: relation_name, options: {})
    end
    
    struct
  end
  
  def self.stories(id, user, page)
    collection = if id == 'no-name'
      Story.exists(_type: false)
    else
      product = Product.find(id)
      
      begin
        product.story_class.for_user(user)
      rescue NotImplementedError
        product.story_class
      end
    end
    
    collection.where(:users_without_tasks_ids.ne => user.id)#.page(page).per(1)
  end
  
  # belongs_to (SQL)
  def user; User.find(offeror_id); end
  def user=(value); self.user_id = value.id; end
  
  # has_many (SQL)
  def areas; Area.where(id: area_ids); end
  
  private
  
  def english_name_available?
    unless attributes['name']['en'].present?
      errors[:name] << I18n.t(
        'activerecord.errors.models.product.attributes.name.missing_english_name'
      )
    end
  end
  
  def existing_model_file?
    unless (get_klass_name.constantize rescue false)
      errors[:name] << I18n.t(
        'activerecord.errors.models.product.attributes.name.missing_model_file'
      )
    end
  end

  def get_klass_name
    if name == 'Product'
      'Product'
    else
      [
        'Product', name.gsub(' - ', '_').gsub('-', '_').gsub(' ', '_').classify
      ].join('::')
    end
  end
  
  def set_klass_name
    if klass_name.present?
      self._type = klass_name
    else
      self._type = get_klass_name
    end
  end
end