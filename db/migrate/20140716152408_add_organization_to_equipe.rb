class AddOrganizationToEquipe < ActiveRecord::Migration
  def change
  	add_column :equipes, :organization_id, :integer 
  end
end
