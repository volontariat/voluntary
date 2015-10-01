class Wikidata
  def self.search(term, known_things)
    begin
      JSON.parse(
        HTTParty.get(
          "https://www.wikidata.org/w/api.php?action=wbsearchentities&search=" +
          "#{URI.encode(term, /\W/)}&format=json&language=en&type=item&continue=0",
          verify: false
        ).body
      )['search'].map do |item|
        description = if item['description'].to_s.present? && 
                         item['description'] != 'Wikimedia disambiguation page'
          " (#{item['description']})"
        else
          ''
        end
        
        "#{item['label']}#{description}"
      end.uniq.select{|i| known_things.select{|t| t[:name] == i }.none? }.map{|item| { name: item } }
    rescue SocketError => e
      []
    end
  end
end