class AddExerciseOrderToTestSets < ActiveRecord::Migration
  def change
  	add_column :test_sets, :exercise_order, :integer 
  end
end
