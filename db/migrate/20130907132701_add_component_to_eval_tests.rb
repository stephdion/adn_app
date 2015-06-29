class AddComponentToEvalTests < ActiveRecord::Migration
  def change
    add_column :eval_tests, :component, :boolean
  end
end
