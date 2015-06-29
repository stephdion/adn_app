class AddLeftRightToEvalTests < ActiveRecord::Migration
  def change
    add_column :eval_tests, :left_right, :boolean
  end
end
