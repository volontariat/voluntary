# from https://github.com/pluginaweek/state_machine/issues/251#issuecomment-31598775
module StateMachine
  module Integrations
     module ActiveModel
        public :around_validation
     end
  end
end