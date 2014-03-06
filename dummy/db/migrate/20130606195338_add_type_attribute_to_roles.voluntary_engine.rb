# This migration comes from voluntary_engine (originally 20121006170407)
class AddTypeAttributeToRoles < ActiveRecord::Migration
  def change
    add_column :roles, :type, :string
  end
end
