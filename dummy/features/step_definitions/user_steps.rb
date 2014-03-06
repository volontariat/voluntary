Given /^a user named "([^\"]*)"$/ do |name|
  @me = FactoryGirl.create(:user, name: name, email: "#{name.gsub(' ', '_')}@volontari.at")  
  @me.reload
end

Given /^current user has role "([^\"]*)"$/ do |name|
  @me.roles << Role.find_or_create_by_name(name)
end