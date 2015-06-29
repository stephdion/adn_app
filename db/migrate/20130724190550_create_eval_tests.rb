class CreateEvalTests < ActiveRecord::Migration
  def change
    create_table :eval_tests do |t|
      t.string :name
      t.string :description
      t.integer :user_id

      t.timestamps
    end
    add_index :eval_tests, [:user_id, :created_at]
  end
end
