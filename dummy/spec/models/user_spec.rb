require 'spec_helper'

describe User do
  describe '#create' do
    it 'generates an API key' do
      user = FactoryGirl.create(:user)
      
      user.api_key.should_not be_nil
    end
  end
  
  describe '#is_master?' do
    context 'is master' do
      it 'returns true' do
        user = FactoryGirl.create(:user, roles: [:master])
        
        user.is_master?.should be_truthy
      end
    end
    
    context 'has no roles' do
      it 'returns false' do
        user = FactoryGirl.create(:user)
        
        user.is_master?.should be_falsey
      end
    end
  end
end
