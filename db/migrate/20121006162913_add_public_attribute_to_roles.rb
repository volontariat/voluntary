class AddPublicAttributeToRoles < ActiveRecord::Migration
  def up
    add_column :roles, :public, :boolean, default: false
    
    roles = []
    
    Role.all.each do |role|
      roles << [role.id, ['Project_owner', 'User'].include?(role.name)]
    end
    
    roles.each do |role|
      Role.find(role.first).update_attribute(:public, role.second)
    end
    
    add_column :users, :main_role_id, :integer
    
    user_role_id = Role.find_or_create_by(name: 'User').id
    User.update_all main_role_id: user_role_id
  end
  
  def down
    remove_column :roles, :public, :boolean
    remove_column :users, :main_role_id, :integer
  end
end
