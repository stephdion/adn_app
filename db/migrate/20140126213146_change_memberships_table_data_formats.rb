class ChangeMembershipsTableDataFormats < ActiveRecord::Migration
  def change
  	remove_column :memberships, :secondary_org_id
  	remove_column :memberships, :secondary_role_id
  	add_column :memberships, :secondary_org_id, :integer
  	add_column :memberships, :secondary_role_id, :integer
  end

end
