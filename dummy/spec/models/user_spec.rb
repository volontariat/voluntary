require 'spec_helper'

describe User do
  describe '#is_master?' do
    context 'is master' do
      it 'returns true' do
        user = FactoryGirl.create(:master_user)
        
        user.is_master?.should be_true
      end
    end
    
    context 'has no roles' do
      it 'returns false' do
        user = FactoryGirl.create(:user)
        
        user.is_master?.should be_false
      end
    end
  end
end
