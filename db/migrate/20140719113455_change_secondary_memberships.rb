class ChangeSecondaryMemberships < ActiveRecord::Migration
  def up
  	rename_column :memberships, :secondary_org_id, :organization_id
  	rename_column :memberships, :secondary_role_id, :role_id
  end

  def down
  	rename_column :memberships, :organization_id, :secondary_org_id 
  	rename_column :memberships, :role_id, :secondary_role_id
  end
end
