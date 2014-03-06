module Voluntary
  module Test
    module RspecHelpers
      class Factories
        def self.code
          Proc.new do |factory_girl|
            factory_girl.factory :user do
              sequence(:name) { |n| "user#{n}#{r_str}" }
              sequence(:email) { |n| "user#{n}#{r_str}@volontari.at" }
              first_name 'Mister'
              last_name { |u| u.name.humanize }
              country 'Germany'
              language 'en'
              interface_language 'en'
              password 'password'
              password_confirmation { |u| u.password }
              
              #after_create do |user|
              #  User.confirm_by_token(user.confirmation_token)
              #end
            end
            
            factory_girl.factory :area do
              sequence(:name) { |n| "area #{n}" }
            end
            
            factory_girl.factory :product do
              name 'Product'
              user_id FactoryGirl.create(:user, password: 'password', password_confirmation: 'password').id
              area_ids [Area.first.try(:id) || FactoryGirl.create(:area).id]
              text Faker::Lorem.sentences(5).join(' ')
              
              after_build do |product|
                product.id = product.name.to_s.parameterize
              end
            end
            
            factory_girl.factory :project do
              association :user
              sequence(:name) { |n| "project #{n}#{r_str}" }
              text Faker::Lorem.sentences(20).join(' ')
              
              after_build do |project|
                resource_has_many(project, :areas) 
              end
            end
            
            factory_girl.factory :vacancy do
              association :project
              sequence(:name) { |n| "vacancy #{n}" }
              text Faker::Lorem.sentences(20).join(' ')
              limit 1
              state 'open'
            end
            
            factory_girl.factory :candidature do
              association :user
              association :vacancy
              sequence(:name) { |n| "candidature #{n}" }
              text Faker::Lorem.sentences(20).join(' ')
            end
            
            factory_girl.factory :comment do
              association :user
              association :commentable, factory: :project
              sequence(:name) { |n| "comment #{n}" }
              text Faker::Lorem.sentences(5).join(' ')
            end
            
            factory_girl.factory :story do
              association :project
              sequence(:name) { |n| "story#{n}#{r_str}" }
              text Faker::Lorem.sentences(10).join(' ')
              event 'setup_tasks'
              state_before 'initialized'
              state 'tasks_defined'
              
              after_build do |story|
                story.tasks << Factory.build(:task, offeror_id: FactoryGirl.create(:project).user_id)
              end
            end
            
            factory_girl.factory :story_without_tasks do
              association :project
              sequence(:name) { |n| "story#{n}#{r_str}" }
              text Faker::Lorem.sentences(10).join(' ')
              language 'en'
              min_length 10
              max_length 50
              with_keywords true
              min_number_of_keywords 1
              max_number_of_keywords 3
              event 'initialization'
              state_before 'new'
              state 'initialized'
            end
            
            factory_girl.factory :task do
              sequence(:name) { |n| "task#{n}#{r_str}" }
              text Faker::Lorem.sentences(10).join(' ')
            end
            
            factory_girl.factory :thing do
              sequence(:name) { |n| "thing #{n} #{r_str}" }
            end
          end
        end
      end
    end
  end
end