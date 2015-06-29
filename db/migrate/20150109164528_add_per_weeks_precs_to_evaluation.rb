class AddPerWeeksPrecsToEvaluation < ActiveRecord::Migration
  def change
  	add_column :evaluations, :point_presc0, :string
  	add_column :evaluations, :point_presc1, :string
  	add_column :evaluations, :point_presc2, :string
  	add_column :evaluations, :point_presc3, :string
  end
end
