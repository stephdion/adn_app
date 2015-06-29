class UpdateUsersRequired < ActiveRecord::Migration
  def up
    change_column :users, :last_name,  :string
    change_column :users, :first_name, :string
  end

  def down
  end

end
