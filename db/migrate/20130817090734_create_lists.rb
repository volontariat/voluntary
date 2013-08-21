class CreateLists < ActiveRecord::Migration
  def up
    create_table :lists, force:  true do |t|
      t.integer :user_id
      t.string :name # alias :topic
      t.timestamps
    end
    
    add_index :lists, :user_id
    
    create_table :list_items, force:  true do |t|
      t.integer :list_id
      t.integer :position
      t.integer :user_id
      t.integer :thing_id
      t.timestamps
    end
    
    add_index :list_items, [:list_id, :position], unique: true
    
    create_table :things, force:  true do |t|
      t.string :name
      t.timestamps
    end
    
    add_index :things, :name, unique: true
  end

  def down
    [:lists, :list_items, :things].each {|table| drop_table table }
  end
end
