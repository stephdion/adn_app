class DropStoredImages < ActiveRecord::Migration
  def up
  	drop_table :stored_images
  end

  def down
  	raise ActiveRecord::IrreversibleMigration
  end
end
