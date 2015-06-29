class Update4Scat2s < ActiveRecord::Migration
  def change
    add_column :scat2s, :return_to_competition, :string
  end

end
