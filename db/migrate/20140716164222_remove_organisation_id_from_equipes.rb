class RemoveOrganisationIdFromEquipes < ActiveRecord::Migration
  def change
  remove_column :equipes, :organisation_id
  end
end
