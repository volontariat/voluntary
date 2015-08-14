class Thing < ActiveRecord::Base
  include Concerns::Model::BaseThing
  
  def self.suggest(term)
    known_things = Thing.order(:name).where("name LIKE ?", "%#{term}%").limit(10).map do |t| 
      { id: t.id, name: t.name }
    end
    
    known_things + Wikidata.search(term, known_things)
  end
end