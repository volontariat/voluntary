module StateMachines::Task
  def self.included(base)
    base.extend ClassMethods
    
    base.class_eval do
      include Model::MongoDb::StateVersionAttributes
      
      attr_accessor :current_user
      
      const_set 'STATES', [:new, :assigned, :under_supervision, :completed]
      const_set 'EVENTS', [:assign, :cancel, :review, :follow_up, :complete]
      
      after_initialize :set_initial_state
      
      state_machine :state, initial: :new do
        event :assign do
          transition :new => :assigned
        end
        
        state :assigned do
          validates :user_id, presence: true
        end
        
        event :cancel do 
          transition :assigned => :new
        end
       
        event :review do
          transition :assigned => :under_supervision
        end
        
        state :under_supervision do
          # TODO: move logic of Workflow::TasksController#update here
          #validates_associated :result
        end
       
        event :follow_up do 
          transition [:under_supervision, :completed] => :assigned
        end
        
        event :complete do
          # TODO: complete the story through observer
          transition :under_supervision => :completed
        end
        
        before_transition do |object, transition|
          object.event = transition.event.to_s
          object.state_before = transition.from
          
          case transition.event
          when :assign
            object.author_id = object.user_id
          when :cancel
            object.unassigned_user_ids ||= []
            object.unassigned_user_ids << object.user_id
            object.user_id = nil
            object.author_id = nil
            object.result.text = nil if object.result
          when :review
            object.user_id = object.offeror_id
          when :follow_up
            object.user_id = object.author_id
          end
        end
        
        after_transition do |object, transition|
          case transition.event
          when :follow_up
            if object.story.completed?
              object.story.activate
            end
          when :complete
            if object.story.tasks.complete.count == object.story.tasks.count
              object.story.complete
            end
          end
        end
      end
      
      private
      
      def set_initial_state
        self.state ||= :new
      end
    end
  end
end