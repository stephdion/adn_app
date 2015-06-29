
class UpdateBlessures3 < ActiveRecord::Migration
  def up
    add_column      :blessures, :equipe_type_id, :int
  end

  def down

  end
end
