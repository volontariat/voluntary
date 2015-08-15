require 'spec_helper'

describe Thing do
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