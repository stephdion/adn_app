class CreatePrescriptions < ActiveRecord::Migration
  def change
    create_table :prescriptions do |t|
		t.integer :eval_test_id
        t.integer :exercise_id
      t.timestamps
    end
  end
end
