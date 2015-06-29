class CreateEquipes < ActiveRecord::Migration
  def change
    create_table :equipes do |t|
	    t.string :name
      t.string :description
      t.integer :equipe_type_id
      t.integer :user_id
      t.integer :organisation_id
      t.integer :coach_id
      t.integer :assistant_id

      t.timestamps
    end
  end
end
