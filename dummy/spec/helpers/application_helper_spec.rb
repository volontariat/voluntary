require 'spec_helper'

module ApplicationHelper
  def resource
    @resource ||= FactoryGirl.create(:user)
  end
end

describe ApplicationHelper do
  describe '#general_attribute?' do
    it 'principally works' do
      helper.general_attribute?(:state).should == true
      helper.general_attribute?(:profession).should == false
    end
  end
  
  describe '#attribute_translation' do
    it 'principally works' do
      helper.attribute_translation(:state).should == I18n.t('attributes.state')
      helper.attribute_translation(:profession).should == I18n.t('activerecord.attributes.user.profession')
    end
  end
end