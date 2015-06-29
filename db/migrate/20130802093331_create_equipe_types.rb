class CreateEquipeTypes < ActiveRecord::Migration
  def change
    create_table :equipe_types do |t|
      t.string :name

      t.timestamps
    end
  end
end
