class AddContactedToResultats < ActiveRecord::Migration
  def change
    add_column :resultats, :contacted, :boolean
  end
end
