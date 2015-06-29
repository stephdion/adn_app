class AddComponentToResultats < ActiveRecord::Migration
  def change
    add_column :resultats, :component, :integer
  end
end
