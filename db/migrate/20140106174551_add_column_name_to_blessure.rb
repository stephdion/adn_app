class AddColumnNameToBlessure < ActiveRecord::Migration
  def change
    add_column :blessures, :operation, :string
    add_column :blessures, :detail, :string
  end
end
