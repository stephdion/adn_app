class AddSubcategoryToExercises < ActiveRecord::Migration
  def change
  	add_column :exercises, :exercise_subcategory_id, :integer 
  end
end
