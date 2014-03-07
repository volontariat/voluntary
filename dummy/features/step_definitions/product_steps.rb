Given /^a product named "([^\"]*)"$/ do |name|
  attributes = {name: name}
  attributes[:user_id] ||= @me.id if @me
  attributes[:area_ids] ||= [Area.last.id] if Area.any?
    
  @product = FactoryGirl.create(:product, attributes) 
  
  @product.reload
end