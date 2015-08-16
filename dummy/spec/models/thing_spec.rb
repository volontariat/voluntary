require 'spec_helper'

describe Thing do
  describe 'validations' do
    describe '#special_characters_excluded' do
      it 'avoids this' do
        thing = FactoryGirl.build(:thing, name: 'Dummy / 1')
        
        thing.valid?
        
        expect(thing.errors[:name]).to include(
          I18n.t(
            'activerecord.errors.models.thing.attributes.name.unwanted_special_characters_included'
          )
        )
      end
    end
  end

  describe '.suggest' do
    it 'decorates suggestions from wikidata with existing things' do
      thing = FactoryGirl.create(:thing, name: 'Dummy')
      
      allow(Wikidata).to receive(:search).and_return([{ name: 'Dummy2'}])
      
      expect(Thing.suggest('Dummy')).to be == [
        { id: thing.id, name: 'Dummy', value: 'Dummy'}, { name: 'Dummy2', value: 'Dummy2'}
      ]
    end
  end
end