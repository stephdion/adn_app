class CreateExerciseSubcategories < ActiveRecord::Migration
  def change
    create_table :exercise_subcategories do |t|
      t.string :name
      t.integer :exercise_category_id

      t.timestamps
    end
  end
end
