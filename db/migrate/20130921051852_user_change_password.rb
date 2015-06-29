class UserChangePassword < ActiveRecord::Migration
  def up
    add_column   :users, :change_password_required, :boolean, null: false, default: false
  end

  def down
    remove_column   :users, :change_password_required, :boolean, :null=>false, default: false
  end
end
