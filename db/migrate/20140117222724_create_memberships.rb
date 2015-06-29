class CreateMemberships < ActiveRecord::Migration
  def change
    create_table :memberships do |t|
      t.integer :user_id
      t.string :organization_id
      t.string :role_id

      t.timestamps
    end
  end
end
