class RemoveCoachAndAssistantFromEquipe < ActiveRecord::Migration
  def change
  	remove_column :equipes, :coach_id
  	remove_column :equipes, :assistant_id
  end
end
