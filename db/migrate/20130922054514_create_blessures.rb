class CreateBlessures < ActiveRecord::Migration
  def change
    create_table :blessures do |t|
      t.string  :titre
      t.string  :date
      t.integer :athlete_id
      t.string  :partie_du_corp
      t.string  :cote_du_corp
      t.string  :type_de_blessure
      t.string  :mechanism
      t.string  :surface
      t.boolean :retour_au_jeu
      t.string  :symptomes_data

      t.timestamps
    end
  end
end
