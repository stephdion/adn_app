class UpdateVouchers < ActiveRecord::Migration
  def up
    add_index :vouchers, :token, :unique => true
    add_index :roles,    :code,  :unique => true
  end

  def down
    remove_index :vouchers, :token
    remove_index :roles,    :code
  end

end
