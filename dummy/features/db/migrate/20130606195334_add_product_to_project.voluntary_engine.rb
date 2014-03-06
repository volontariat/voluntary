# This migration comes from voluntary_engine (originally 20120923140109)
class AddProductToProject < ActiveRecord::Migration
  def change
    add_column :projects, :product_id, :string
    add_index :projects, :product_id
  end
end
