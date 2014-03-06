module VacancyFactoryMethods
  def set_vacancy_defaults(attributes)
    unless attributes[:resource] || attributes[:resource_id] || !@me
      attributes[:resource_id] ||= @me.id
      attributes[:resource_type] ||= 'User'
    end
    
    attributes[:project_id] ||= Project.last.id unless attributes[:project_id] || Project.all.none?
  end
  
  def new_vacancy(name, state = nil)
    attributes = { name: name }
    attributes[:state] = state if state
    
    set_vacancy_defaults(attributes)
    
    @vacancy = FactoryGirl.create(:vacancy, attributes)
    @vacancy.reload
  end
end

World(VacancyFactoryMethods)

Given /^a vacancy named "([^\"]*)"$/ do |name|
  new_vacancy(name)
end

Given /^a vacancy named "([^\"]*)" with state "([^\"]*)"$/ do |name, state|
  new_vacancy(name, state)
end

Then /^I should see the following vacancies:$/ do |expected_table|
  rows = find('table').all('tr')
  table = rows.map { |r| r.all('th,td').map { |c| c.text.strip } }
  expected_table.diff!(table)
end
