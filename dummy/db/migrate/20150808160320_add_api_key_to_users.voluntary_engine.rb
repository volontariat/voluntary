# This migration comes from voluntary_engine (originally 20150808155719)
class AddApiKeyToUsers < ActiveRecord::Migration
  def up
    add_column :users, :api_key, :string, limit: 32
    add_index :users, :api_key
    
    User.where('api_key IS NULL').find_each do |user|
      begin
        user.api_key = SecureRandom.uuid.tr('-', '')
      end while User.where(api_key: user.api_key).any?
      
      user.save!
    end
  end
  
  def down
    remove_column :users, :api_key
  end
end
