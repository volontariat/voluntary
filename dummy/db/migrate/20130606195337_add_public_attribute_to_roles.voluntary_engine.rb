# This migration comes from voluntary_engine (originally 20121006162913)
class AddPublicAttributeToRoles < ActiveRecord::Migration
  def change
    add_column :roles, :public, :boolean, default: false
    add_column :users, :main_role_id, :integer
  end
end
