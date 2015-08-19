delivery_method_was = ActionMailer::Base.delivery_method
ActionMailer::Base.delivery_method = :test

User.create!(
  name: 'Administrator', first_name: 'Mister', last_name: 'Admin', email: 'admin@test.com', 
  language: 'en', country: 'DE', interface_language: 'en', password: 'administrator', 
  password_confirmation: 'administrator', roles: 1
)

ActionMailer::Base.delivery_method = delivery_method_was
