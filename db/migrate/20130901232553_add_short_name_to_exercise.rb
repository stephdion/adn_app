class AddShortNameToExercise < ActiveRecord::Migration
  def change
    add_column :exercises, :short_name, :string
  end
end
