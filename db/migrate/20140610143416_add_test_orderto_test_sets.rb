class AddTestOrdertoTestSets < ActiveRecord::Migration
  def change
  	add_column :test_sets, :test_order, :integer 
  end
end
