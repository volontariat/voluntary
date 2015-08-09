Given /^a user named "([^\"]*)"$/ do |name|
  @me = FactoryGirl.create(:user, name: name, email: "#{name.gsub(' ', '_')}@volontari.at")  
  @me.reload
end

Given /^current user has role "([^\"]*)"$/ do |name|
  @me.roles ||= []
  @me.roles << name.tableize.singularize.to_sym
  @me.save!
end