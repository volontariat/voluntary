require 'spec_helper'

describe Wikidata do
  describe '.search' do
    it 'requests wikidata search and returns uniq names not included in known things array' do
      allow(HTTParty).to receive(:get).with(
        "https://www.wikidata.org/w/api.php?action=wbsearchentities&search=" +
        "Dummy&format=json&language=en&type=item&continue=0",
        verify: false
      ).and_return(
        Struct.new(:body).new(
          {
            'search' => [
              { 'label' => 'Dummy' }, { 'label' => 'Dummy2', 'description' => 'Description' },
              { 'label' => 'Dummy3' }
            ]
          }.to_json
        )
      )
      
      expect(Wikidata.search('Dummy', [{ id: 1, name: 'Dummy' }])).to be == [
        { name: 'Dummy2 (Description)'}, { name: 'Dummy3'},
      ]
    end
  end
end