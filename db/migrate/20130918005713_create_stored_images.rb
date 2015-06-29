class CreateStoredImages < ActiveRecord::Migration
  def change
    create_table :stored_images do |t|
      t.boolean :used
      t.string :desrciption

      t.timestamps
    end
  end
end
