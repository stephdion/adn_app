class ChangeStringtoTextDescription < ActiveRecord::Migration
  def up
  	change_column :eval_tests, :description, :text
  	change_column :exercises, :description, :text
  	change_column :programmes, :description, :text
  	change_column :evaluations, :description, :text
  end

  def down
  	change_column :eval_tests, :description, :string
  	change_column :exercises, :description, :string
  	change_column :programmes, :description, :string
  	change_column :evaluations, :description, :string
  end
end
