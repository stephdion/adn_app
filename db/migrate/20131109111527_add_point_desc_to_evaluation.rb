class AddPointDescToEvaluation < ActiveRecord::Migration
  def change
    add_column :evaluations, :point_desc0, :string
    add_column :evaluations, :point_desc1, :string
    add_column :evaluations, :point_desc2, :string
    add_column :evaluations, :point_desc3, :string
  end
end
