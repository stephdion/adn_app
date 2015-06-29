class CreateBodysides < ActiveRecord::Migration
  def change
    create_table :bodysides do |t|
      t.string :name_fr,    :required=>true
      t.string :code,       :required=>true, :unique => true
      t.string :description

      t.timestamps
    end
    add_index(:bodysides, [:code],  :unique => true)

    Bodyside.create(:code=>"bs_left",       :name_fr=>"Gauche");
    Bodyside.create(:code=>"bs_right",      :name_fr=>"Droite");
    Bodyside.create(:code=>"bs_na",         :name_fr=>"Non applicable");
  end
end
