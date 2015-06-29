class AddVideoToEvalTests < ActiveRecord::Migration
  def change
    add_column :eval_tests, :video, :string
  end
end
