class UpdateUsersPhones < ActiveRecord::Migration
  def up
    rename_column :user_phones,         :type,           :phone_type
  end

  def down
  end

end
