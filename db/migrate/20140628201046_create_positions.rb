class CreatePositions < ActiveRecord::Migration
  def change
    create_table :positions do |t|
      t.string :position
      t.integer :equipe_type

      t.timestamps
    end
  end
end
