module StateMachines::Story
  def self.included(base)
    base.extend ClassMethods
    
    base.class_eval do
      include Model::MongoDb::StateVersionAttributes
      
      attr_accessor :current_user
      
      const_set 'STATES', [:new, :tasks_defined, :active, :completed, :closed]
      const_set 'EVENTS', [:initialization, :setup_tasks, :activate, :complete]
      
      after_initialize :set_initial_state
      
      state_machine :state, initial: :new do
        event :initialization do
          transition :new => :initialized
        end
        
        event :setup_tasks do
          transition :initialized => :tasks_defined  
        end
        
        state :tasks_defined do
          #validates_associated :tasks
          validate :presence_of_tasks
        end
        
        state :active do
          validate :presence_of_tasks
        end
        
        event :activate do
          transition [:new, :tasks_defined, :completed] => :active
        end
        
        event :deactivate do
          transition :active => :tasks_defined
        end
        
        event :complete do
          transition :active => :completed
        end
        
        event :close do
          transition :completed => :closed
        end
        
        before_transition do |object, transition|
          object.event = transition.event.to_s
          object.state_before = transition.from
        end
      end
      
      private
      
      def set_initial_state
        self.state ||= :new
      end
      
      def presence_of_tasks
        self.tasks.delete_if do |t| 
          t.name.blank? && (t.class.name == 'Task' && t.text.blank?)
        end
        
        if tasks.select{|t| !t.valid?}.any?
          errors[:base] << I18n.t(
            'activerecord.errors.models.story.attributes.base.invalid_tasks'
          )
        end
        
        if tasks.none?
          errors[:base] << I18n.t(
            'activerecord.errors.models.story.attributes.base.missing_tasks'
          )
        end
      end
    end
  end
end