require 'spec_helper'

describe 'Argument' do
  describe 'scopes' do
    describe '.compare_two_argumentables' do
      before :each do
        @left_thing = Factory(:thing, name: 'Left thing')
        @right_thing = Factory(:thing, name: 'Right thing')
        
        Argument.create_with_topic(1, argumentable_type: 'Thing', argumentable_name: @left_thing.name, topic_name: 'Both', value: 1)
        Argument.create_with_topic(1, argumentable_type: 'Thing', argumentable_name: @right_thing.name, topic_name: 'Both', value: 2)
        Argument.create_with_topic(1, argumentable_type: 'Thing', argumentable_name: @left_thing.name, topic_name: 'Left', value: 3)
        Argument.create_with_topic(1, argumentable_type: 'Thing', argumentable_name: @right_thing.name, topic_name: 'Right', value: 4)
      end
      
      context 'side is both' do
        it 'returns data for both sides' do
          arguments = Argument.compare_two_argumentables('Thing', 'both', @left_thing.name, @right_thing.name).to_a
          
          arguments.length.should == 1
          arguments.first.topic_name.should == 'Both'
          arguments.first.value.should == '1'
          arguments.first.right_value.should == '2'
        end
      end
      
      context 'side is left' do
        it 'returns only data for left side' do
          arguments = Argument.compare_two_argumentables('Thing', 'left', @left_thing.name, @right_thing.name).to_a
          
          arguments.length.should == 1
          arguments.first.topic_name.should == 'Left'
          arguments.first.value.should == '3'
          arguments.first.right_value.should == nil
        end
      end
      
      context 'side is right' do
        it 'returns only data for right side' do
          arguments = Argument.compare_two_argumentables('Thing', 'right', @left_thing.name, @right_thing.name).to_a
          
          arguments.length.should == 1
          arguments.first.topic_name.should == 'Right'
          arguments.first.value.should == '4'
          arguments.first.right_value.should == nil     
        end
      end
    end 
  end
  
  describe '.create_with_topic' do
    context 'topic_name is blank' do
      it 'returns an error' do
        Argument.create_with_topic(1, topic_name: '').should == { errors: { topic: { name: ["can't be blank"] } }}
      end
    end

    context 'topic does not exist' do
      it 'creates a new topic' do
        expect do 
          Argument.create_with_topic(
            1, topic_name: 'Dummy', argumentable_type: 'Thing', argumentable_id: FactoryGirl.create(:thing).id, value: 'Dummy'
          )
        end.to change{ArgumentTopic.count}
      end
    end
    
    context 'topic already exists' do
      it 'creates no new topic' do
        topic = FactoryGirl.create(:argument_topic, name: 'Dummy')
        
        expect do 
          Argument.create_with_topic(
            1, topic_name: 'Dummy', argumentable_type: 'Thing', argumentable_id: FactoryGirl.create(:thing).id, value: 'Dummy'
          )
        end.to_not change{ArgumentTopic.count}
      end
    end
    
    context 'argument invalid' do
      it 'returns an error' do
        response = Argument.create_with_topic(1, argumentable_type: 'Thing', topic_name: 'Dummy', value: 'Dummy')
        
        response[:errors][:argumentable_id].should == ["can't be blank"]
      end
    end
  end
end