
class UpdateBlessures2 < ActiveRecord::Migration
  def up
    remove_column   :blessures, :titre

  end

  def down

  end
end
