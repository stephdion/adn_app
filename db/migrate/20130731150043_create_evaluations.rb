class CreateEvaluations < ActiveRecord::Migration
  def change
    create_table :evaluations do |t|
      t.string :name
      t.string :description
      t.integer :user_id

      t.timestamps
    end
  end
end
