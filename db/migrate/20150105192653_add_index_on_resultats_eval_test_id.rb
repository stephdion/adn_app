class AddIndexOnResultatsEvalTestId < ActiveRecord::Migration
  def change
  	add_index :resultats, :eval_test_id
  end
end
