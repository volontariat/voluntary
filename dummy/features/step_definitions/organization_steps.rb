Given /^an organization named "([^\"]*)"$/ do |name|
  @organization = FactoryGirl.create(:organization, name: name) 
  @organization.reload
end

Given /^an organization named "([^\"]*)" assigned to me$/ do |name|
  @organization = FactoryGirl.create(:organization, name: name, user: @me) 
  @organization.reload
end

Given /^2 organizations assigned to me$/ do
  FactoryGirl.create(:organization, name: 'organization 1', user: @me) 
  FactoryGirl.create(:organization, name: 'organization 2', user: @me) 
end