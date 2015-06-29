class CreateExercises < ActiveRecord::Migration
  def change
    create_table :exercises do |t|
      t.string :name
      t.string :description
      t.integer :user_id
      t.string :video

      t.timestamps
    end
    add_index :exercises, [:user_id ]
  end
end
