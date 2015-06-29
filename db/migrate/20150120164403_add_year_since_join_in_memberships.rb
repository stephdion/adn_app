class AddYearSinceJoinInMemberships < ActiveRecord::Migration
  def up
      add_column :memberships, :year_since_join, :date
  end

  def down
      remove_column :memberships, :year_since_join
  end
end
