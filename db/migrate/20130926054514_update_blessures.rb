class UpdateBlessures < ActiveRecord::Migration
  def up
    #change_column   :users, :isEnabled, :boolean, :null=>false
    change_column   :blessures, :athlete_id, :int, :null=>false
    rename_column   :blessures, :athlete_id, :user_id
    remove_column   :blessures, :date
    add_column      :blessures, :date, :date, :null=>false, :default=>DateTime.now

  end

  def down

  end
end
