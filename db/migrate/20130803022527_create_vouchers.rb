class CreateVouchers < ActiveRecord::Migration
  def change
    create_table :vouchers do |t|
      t.string  :token,          :unique=>true, :required=>true
      t.text    :description
      t.integer :role_id
      t.integer :organization_id
      t.boolean :isEnable,         :default=>true
      t.boolean :isSystem,         :default=>false

      t.timestamps
    end
    #add_index :vouchers, [:role_id ]

  end
end
