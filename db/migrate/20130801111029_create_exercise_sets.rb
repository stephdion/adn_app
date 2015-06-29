class CreateExerciseSets < ActiveRecord::Migration
  def change
    create_table :exercise_sets do |t|
      t.integer :exercise_id
      t.integer :programme_id

      t.timestamps
    end
  end
end
