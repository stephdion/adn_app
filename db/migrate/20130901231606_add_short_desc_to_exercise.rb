class AddShortDescToExercise < ActiveRecord::Migration
  def change
    add_column :exercises, :short_desc, :string
  end
end
