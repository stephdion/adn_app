class UpdateUsersAddress < ActiveRecord::Migration
  def up
    add_column    :users,         :address,           :string
    add_column    :users,         :city,              :string
    add_column    :users,         :state,             :string
    add_column    :users,         :postalCode,        :string
    add_column    :users,         :country,           :string

    create_table :user_phones do |t|
      t.string  :type    , null: false
      t.string  :number  , null: false
      t.integer :user_id , null: false

      t.timestamps
    end
  end

  def down
    remove_column    :users,         :address,           :string
    remove_column    :users,         :city,              :string
    remove_column    :users,         :state,             :string
    remove_column    :users,         :postalCode,        :string
    remove_column    :users,         :country,           :string

    drop_table :user_phones
  end

end
