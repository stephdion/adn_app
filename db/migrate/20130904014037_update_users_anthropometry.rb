class UpdateUsersAnthropometry < ActiveRecord::Migration
  def up
    add_column    :users,         :birthday,   :date
    add_column    :users,         :sex,           :string

    create_table  :user_anthropometry do |t|
      t.integer       :height         , null: true
      t.integer       :weight         , null: true
      t.integer       :user_id        , null: true

      t.timestamps
    end
  end

  def down
    remove_column    :users,         :dateOfBirth,   :date
    remove_column    :users,         :sex,           :string

    drop_table :user_anthropometry
  end

end
