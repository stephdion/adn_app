class AddExerciseOrderToPrescriptions < ActiveRecord::Migration
  def change
  	add_column :prescriptions, :exercise_order, :integer
  end
end
