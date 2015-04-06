require 'spec_helper'

class ChildStory < Story
end

describe Product do
  describe 'member methods' do
    describe 'next_task_for_user' do
      it 'principally works' do
        subject = FactoryGirl.create(:story)
        subject.activate!
        ChildStory.create!(name: 'Dummy', project_id: subject.project_id, offeror_id: subject.offeror_id, text: 'Dummy')
        user = FactoryGirl.create(:user)
        
        next_task = subject.next_task_for_user(user)
        next_task.id.should == subject.tasks.first.id
        
        next_task = subject.next_task_for_user(user)
        next_task.id.should == subject.tasks.first.id
        Product.stories('no-name', user).count.should == 1
        
        next_task.cancel!
        next_task = subject.next_task_for_user(user)
        next_task.should == nil
        subject.users_without_tasks_ids.include?(user.id).should == true
        Product.stories('no-name', user).count.should == 0
      end
    end
  end
end
