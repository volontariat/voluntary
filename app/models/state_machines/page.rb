module StateMachines::Page
  def self.included(base)
    base.extend ClassMethods
    
    base.class_eval do
      attr_accessor :current_user
      
      const_set 'STATES', [:active]
      const_set 'EVENTS', []
      
      after_initialize :set_initial_state
      
      state_machine :state, initial: :active do
      end
      
      private
      
      def set_initial_state
        self.state ||= :active
      end
    end
  end
  
  module ClassMethods
  end
end