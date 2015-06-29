class AddIndexOnParticipationId < ActiveRecord::Migration
  def change
  	add_index :participations, [:user_id, :equipe_id]
  end
end
