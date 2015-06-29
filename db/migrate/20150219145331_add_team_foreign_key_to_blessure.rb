class AddTeamForeignKeyToBlessure < ActiveRecord::Migration
  def up
  	add_column :blessures, :equipe_id, :integer
  	add_foreign_key :blessures, :equipes
  end
  def down
  	remove_column :blessures, :equipe_id
  	remove_foreign_key :blessures, :equipes
  end
end
