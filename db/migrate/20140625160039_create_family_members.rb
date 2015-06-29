class CreateFamilyMembers < ActiveRecord::Migration
  def change
    create_table :family_members do |t|
      t.integer :user_id
      t.integer :parent_id
      t.string :relationship

      t.timestamps
    end
  end
end
