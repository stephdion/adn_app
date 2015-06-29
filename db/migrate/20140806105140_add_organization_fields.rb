class AddOrganizationFields < ActiveRecord::Migration
  def change
  	add_column :equipe_types, :organization_id, :integer
  	add_column :eval_tests, :organization_id, :integer
  	add_column :evaluations, :organization_id, :integer
  	add_column :exercises, :organization_id, :integer
  	add_column :exercise_categories, :organization_id, :integer
  	add_column :exercise_subcategories, :organization_id, :integer
  	add_column :test_categories, :organization_id, :integer
  	add_column :test_subcategories, :organization_id, :integer
  	add_column :positions, :organization_id, :integer
  end
end
