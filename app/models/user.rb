class User < ActiveRecord::Base
  include ::Applicat::Mvc::Model::Resource::Base
  include User::Listable
  include User::Extensions
  include User::Omniauthable
  include User::Liking
  
  belongs_to :profession
  
  has_and_belongs_to_many :areas
  has_and_belongs_to_many :projects
  
  has_many :arguments, dependent: :nullify
  has_many :organizations, dependent: :destroy
  def stories; Story.where(offeror_id: id); end
  
  accepts_nested_attributes_for :areas, allow_destroy: true
  
  serialize :foreign_languages
  
  validates :name, presence: true, uniqueness: true, if: 'provider.blank?'
  validates :first_name, presence: true, if: 'provider.blank?'
  validates :last_name, presence: true, if: 'provider.blank?'
  validates :language, presence: true, if: 'provider.blank?'
  validates :country, presence: true, if: 'provider.blank?'
  validates :interface_language, presence: true, if: 'provider.blank?'
        
  attr_accessible :name, :password, :password_confirmation, :remember_me, :text, :language, :first_name, :last_name, 
                  :salutation, :marital_status, :family_status, :date_of_birth, :place_of_birth, :citizenship, 
                  :email, :country, :language, :interface_language, :foreign_language_tokens, :profession_id, 
                  :employment_relationship, :area_tokens, :remember_me, :timezone
       
  # :timeoutable, :token_authenticatable, :lockable,
  # :lock_strategy => :none, :unlock_strategy => :nones
  devise :database_authenticatable, :registerable,# :confirmable,
         :recoverable, :rememberable, :trackable, :validatable
  devise :omniauthable, omniauth_providers: [:facebook, :google_oauth2, :lastfm]
  
  extend FriendlyId
  
  friendly_id :name, use: :slugged     
  
  bitmask :roles, as: [:master]
  
  before_create :create_api_key
                  
  PARENT_TYPES = ['area', 'project']
  
  def self.by_slug_or_id(id)
    id.to_i.to_s == id.to_s ? find(id) : friendly.find(id)
  end
  
  def self.languages(query = nil)
    options = []
    
    AVAILABLE_LANGUAGES.merge(OTHER_LANGUAGES).each do |locale, language|
      next if query && !language.downcase.match(query.downcase)
      
      if query
        options << { id: locale, name: language }
      else
        options << [language, locale]
      end
    end
    
    options
  end
  
  def is_master?
    roles.include? :master
  end
  
  def languages
    (foreign_languages || []) + [language]
  end
  
  def foreign_language_tokens=(tokens)
    self.foreign_languages = tokens.split(',')
  end
  
  def foreign_language_tokens
    options = []
    
    User.languages.each do |language|
      next unless (foreign_languages  || []).include?(language.second)
        
      options << { id: language.second, name: language.first } 
    end
    
    options
  end
  
  def area_tokens=(tokens)
    self.area_ids = Area.ids_from_tokens(tokens)
  end
  
  def area_tokens
    areas
  end
  
  def full_name
    [first_name, last_name].join(' ')
  end
  
  def best_available_name
    lastfm_user_name || full_name
  end
  
  private
  
  def create_api_key
    begin
      self.api_key = SecureRandom.uuid.tr('-', '')
    end while User.where(api_key: api_key).any?
  end
  
  def should_generate_new_friendly_id?
    slug.blank? || name_changed?
  end
end