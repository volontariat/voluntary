Given /^an area named "([^\"]*)"$/ do |name|
  # WORKAROUND: get rid of area query. Don't know why it doesn't work without (e.g. /roles/2_users/projects.feature)
  @area = Area.where(name: name).first || FactoryGirl.create(:area, name: name) 
  @area.reload
end