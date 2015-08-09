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
  
  describe '#create' do
    context 'is valid' do
      it 'returns the task JSON' do
        story = FactoryGirl.create(:story)
        
        post :create, api_key: story.project.user.api_key, story_id: story.id, tasks: [{ name: 'Dummy1', text: 'Dummy2' }], format: 'json'
        
        json = JSON.parse response.body
        json[0]['id'].should_not be_nil
        json[0]['name'] == 'Dummy1'
        json[0]['text'] == 'Dummy2'
      end
    end
    
    context 'is invalid' do
      it 'returns errors as JSON' do
        story = FactoryGirl.create(:story)
        
        post :create, api_key: story.project.user.api_key, story_id: story.id, tasks: [{ name: 'Dummy1' }], format: 'json'
        
        json = JSON.parse response.body
        json[0]['errors']['text'] == "can't be blank"
      end
    end
  end
end