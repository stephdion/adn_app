class RemoveOrgAndRoleFromUser < ActiveRecord::Migration
  def up
  	remove_column :users, :organization_id
  	remove_column :users, :role_id
  end

  def down
  	add_column :users, :organization_id, :integer
  	add_column :users, :role_id, :integer
  end
end
