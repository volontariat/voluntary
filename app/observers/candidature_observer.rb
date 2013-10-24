class CandidatureObserver < ActiveRecord::Observer
  def after_create(candidature)
  end
  
  def before_transition(object, transition)
  end
 
  def after_transition(object, transition)
    case transition.to
      when 'accepted'
        if object.resource_type == 'User'
          ProjectUser.find_or_create_by_project_id_and_vacancy_id_and_user_id!(
            project_id: object.vacancy.project_id, vacancy_id: object.vacancy_id, 
            user_id: object.resource_id
          )
        end
        
        if object.vacancy.limit.present? && object.vacancy.limit == object.vacancy.candidatures.accepted.count
          object.vacancy.close! unless object.vacancy.closed?
        end
      when 'denied'
        # if comming from :accepted then the vacancy offerer has to reopen the vacancy manually
    end
  end
end