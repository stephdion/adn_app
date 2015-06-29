class CreateProgrammes < ActiveRecord::Migration
  def change
    create_table :programmes do |t|
	  t.string :name
      t.string :description
      t.integer :user_id
      
      t.timestamps
    end
  end
end
