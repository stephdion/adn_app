class CreateScat2s < ActiveRecord::Migration
  def change
    create_table :scat2s do |t|
      t.integer :user_id, :null=>false
      t.integer  :equipe_type_id, :null=>false
      t.datetime :incident_datetime, :null=>false
      t.datetime :evaluation_datetime, :null=>false
      t.integer  :owner_id, :null=>false

      t.integer :symptoms_physical
      t.integer :symptoms_mental
      t.string  :behaviour_change
      t.integer :unconsciousness
      t.integer :unconsciousness_time
      t.integer :balance_problem
      t.integer :glasgow_eye
      t.integer :glasgow_verbal
      t.integer :glasgow_mouvement
      t.integer :maddocks_state
      t.integer :maddocks_half_time
      t.integer :maddocks_last_goal
      t.integer :maddocks_last_team
      t.integer :maddocks_last_win
      t.integer :cognitive_month
      t.integer :cognitive_date
      t.integer :cognitive_day
      t.integer :cognitive_year
      t.integer :cognitive_hrs
      t.integer :concentration_inverse_month
      t.integer :stability_two_feet
      t.integer :stability_one_foot
      t.integer :stability_feet_aligned
      t.integer :coordination
      t.integer :cognition_differed_memory

      t.timestamps
    end

    create_table :scat2_symptoms do |t|
      t.string  :code, :null=>false
      t.integer :value, :null=>false
      t.integer :scat2_id, :null=>false

      t.timestamps
    end
  end
end
