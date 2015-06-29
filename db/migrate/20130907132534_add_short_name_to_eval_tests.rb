class AddShortNameToEvalTests < ActiveRecord::Migration
  def change
    add_column :eval_tests, :short_name, :string
  end
end
