class AddPositionToParticipations < ActiveRecord::Migration
  def change
  	add_column :participations, :position_id, :integer 
  end
end
