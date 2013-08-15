delivery_method_was = ActionMailer::Base.delivery_method
ActionMailer::Base.delivery_method = :test

db_seed = VolontariatSeed.new
db_seed.create_fixtures

ActionMailer::Base.delivery_method = delivery_method_was
