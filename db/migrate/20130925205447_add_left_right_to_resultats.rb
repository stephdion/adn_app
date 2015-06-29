class AddLeftRightToResultats < ActiveRecord::Migration
  def change
    add_column :resultats, :left_side, :integer
  end
end
