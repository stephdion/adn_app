class AddEvaluationTypeToEvaluations < ActiveRecord::Migration
  def change
  	add_column :evaluations, :eval_type_id, :integer
  end
end
