class AddSubcategoryToTests < ActiveRecord::Migration
  def change
  	add_column :eval_tests, :test_subcategory_id, :integer 
  end
end
