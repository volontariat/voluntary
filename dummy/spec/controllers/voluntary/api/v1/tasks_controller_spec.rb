require 'spec_helper'

describe Voluntary::Api::V1::TasksController do
  describe '#index' do
    it 'principally works' do
      story = FactoryGirl.create(:story)
      task = story.tasks.first
      result = Result.create(task_id: task.id, text: 'Dummy')
      
      get :index, story_id: story.id, format: 'json'
      
      json = JSON.parse response.body
      
      json['total_entries'].should == 1
      json['entries'][0]['id'].should == task.id.to_s
      json['entries'][0]['result']['id'].should == result.id.to_s
    end
  end
end