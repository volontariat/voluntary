class Ability
  include CanCan::Ability
  
  @@after_initialize_callbacks = []
  
  def initialize(user, options = {})
    controller_namespace = options[:controller_namespace] || ""
    project = options[:project] || nil
    
    alias_action :index, :show, :autocomplete, :parents, :childs, :tree, to: :read
    
    alias_action :new, :create, :edit, :update, :destroy, to: :restful_actions
    alias_action [], to: :admin_actions
    alias_action [], to: :moderation_actions
    alias_action :assign, :reject, :hold_on, to: :supervisor_actions
    
    alias_action :restful_actions, :admin_actions, to: :administrate
    alias_action :restful_actions, :moderation_actions, to: :moderate
    alias_action :read, :assign_actions, to: :supervisor
    
    can :read, [
      Area, Organization, Profession, Product, Project, Story, Task, Result, Comment
    ]
    can [:read, :check_name, :check_url, :check_email, :check_email_unblocked], User
    can :show, Page
    
    if user.present?
      can :destroy, User, id: user.id
      
      can [:new, :create], [Area, Profession, Project, Comment, Like]
      can :assign, Task
      can [:update, :cancel, :review], [Task, Like], user_id: user.id
      
      { 
        user_id: [Product, Organization, Project, Comment, ProjectUser, Result], 
        offeror_id: [Story, Task]
      }.each do |attribute, classes|
        can :restful_actions, classes, attribute => user.id   
      end
      
      can Story::EVENTS, Story, offeror_id: user.id
      can Task::EVENTS + [:update], Task, offeror_id: user.id
      
      if user.is_master?
        can [:manage, :moderate, :administrate, :supervisor], :all
      end
    end
     
    self.class.run_after_initialize_callbacks(self, user, options)
  end
  
  def self.add_after_initialize_callback(proc)
    @@after_initialize_callbacks << proc
  end
  
  def self.run_after_initialize_callbacks(ability, user, options = {})
    @@after_initialize_callbacks.each do |callback|
      callback.call(ability, user, options)
    end
  end
end
