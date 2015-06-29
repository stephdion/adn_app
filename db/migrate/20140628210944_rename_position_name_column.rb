class RenamePositionNameColumn < ActiveRecord::Migration
  def up
  	rename_column :positions, :position, :name
  end

  def down
  	rename_column :positions, :name, :position
  end
end
