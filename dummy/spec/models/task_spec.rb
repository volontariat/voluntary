require 'spec_helper'

describe Task do
  describe 'validations' do
    describe 'reserved_words_exclusion' do
      it 'assures that no reserved word has been chosen' do
        subject = Task.new(story: FactoryGirl.create(:story), name: 'next', text: 'Dummy')
        subject.offeror = FactoryGirl.create(:user)
        subject.save!
        subject.slug.should == 'next-1'
      end
    end
  end
end
