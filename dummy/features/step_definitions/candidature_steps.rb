module CandidatureFactoryMethods
  def set_candidature_defaults(attributes)
    unless attributes[:resource] || attributes[:resource_id] || !@me
      attributes[:resource_type] ||= 'User'
      attributes[:resource_id] ||= @me.id
    end
    
    attributes[:vacancy_id] ||= Vacancy.last.id unless attributes[:vacancy_id] || Vacancy.all.none?
    attributes[:offeror_id] ||= Vacancy.find(attributes[:vacancy_id]).project.user_id if attributes[:vacancy_id]
  end
  
  def new_candidature(name, state = nil)
    attributes = { name: name }
    attributes[:state] = state if state
    
    set_candidature_defaults(attributes)
    
    @candidature = FactoryGirl.create(:candidature, attributes) 
    
    @candidature.reload
  end
end

World(CandidatureFactoryMethods)

Given /^a candidature named "([^\"]*)"$/ do |name|
  new_candidature(name)
end

Given /^a candidature named "([^\"]*)" with state "([^\"]*)"$/ do |name,state|
  new_candidature(name, state)
end

Given /^2 candidatures$/ do
  FactoryGirl.create(:candidature, name: 'candidature 1', vacancy_id: Vacancy.find_by_name('vacancy 1').id, resource_type: 'User', resource_id: User.find_by_name('user').id)
  FactoryGirl.create(:candidature, name: 'candidature 2', vacancy_id: Vacancy.find_by_name('vacancy 1').id, resource_type: 'User', resource_id: User.find_by_name('user 2').id)
end
