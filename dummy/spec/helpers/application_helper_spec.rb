require 'spec_helper'

module ApplicationHelper
  def resource
    @resource ||= FactoryGirl.create(:vacancy)
  end
end

describe ApplicationHelper do
  describe '#general_attribute?' do
    it 'principally works' do
      helper.general_attribute?(:state).should == true
      helper.general_attribute?(:limit).should == false
    end
  end
  
  describe '#attribute_translation' do
    it 'principally works' do
      helper.attribute_translation(:state).should == 'State'
      helper.attribute_translation(:limit).should == 'Limit'
    end
  end
end