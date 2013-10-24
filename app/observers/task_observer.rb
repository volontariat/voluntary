class TaskObserver < ActiveRecord::Observer
  def before_transition(object, transition)
    object.before_transition(transition)
  end
  
  def after_transition(object, transition)
    object.after_transition(transition)
  end
end