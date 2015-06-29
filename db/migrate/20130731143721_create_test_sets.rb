class CreateTestSets < ActiveRecord::Migration
  def change
    create_table :test_sets do |t|
      t.integer :eval_test_id
      t.integer :evaluation_id

      t.timestamps
    end
  end
end
