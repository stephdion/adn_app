class CreateResultats < ActiveRecord::Migration
  def change
    create_table :resultats do |t|
		t.integer :user_id
		t.integer :equipe_id
		t.integer :athlete_id
		t.integer :evaluation_id
		t.integer :eval_test_id
		t.integer :value
      t.timestamps
    end
  end
end
