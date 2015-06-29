class AddIdToEquipeType < ActiveRecord::Migration
  def change
  	rename_column :positions, :equipe_type, :equipe_type_id
  end
end
