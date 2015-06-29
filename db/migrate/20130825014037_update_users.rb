class UpdateUsers < ActiveRecord::Migration
  def up
    add_column    :users,         :isEnabled,            :boolean
    add_column    :users,         :first_name,           :string
    rename_column :users,         :name,                 :last_name
  end

  def down
    remove_column :users,         :role_id,            :int
  end

end
