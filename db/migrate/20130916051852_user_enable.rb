class UserEnable < ActiveRecord::Migration
  def up
    User.update_all({:isEnabled=>true}, {:isEnabled=>nil})
    change_column   :users, :isEnabled, :boolean, :null=>false
  end

  def down
  end
end
