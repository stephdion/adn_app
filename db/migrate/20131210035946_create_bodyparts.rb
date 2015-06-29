class CreateBodyparts < ActiveRecord::Migration
  def change
    create_table :bodyparts do |t|
      t.string :name_fr,    :required=>true
      t.string :code,       :required=>true, :unique => true
      t.string :description

      t.timestamps
    end
    add_index(:bodyparts, [:code],  :unique => true)

    Bodypart.create(:code=>"bp_blow",       :name_fr=>"Coude");
    Bodypart.create(:code=>"bp_head",       :name_fr=>"Tete/visage");
    Bodypart.create(:code=>"bp_arm",        :name_fr=>"Bras");
    Bodypart.create(:code=>"bp_hand",       :name_fr=>"Main");
    Bodypart.create(:code=>"bp_knee",       :name_fr=>"Genou");
    Bodypart.create(:code=>"bp_thigh",      :name_fr=>"Cuisse");
    Bodypart.create(:code=>"bp_lowerleg",   :name_fr=>"Bas de jambe");
    Bodypart.create(:code=>"bp_ft",         :name_fr=>"Pied");
    Bodypart.create(:code=>"bp_fnt",        :name_fr=>"Doigt");
    Bodypart.create(:code=>"bp_toe",        :name_fr=>"Orteil");
    Bodypart.create(:code=>"bp_neck",       :name_fr=>"Cou");
    Bodypart.create(:code=>"bp_hip",        :name_fr=>"Bassin/Hanche");
    Bodypart.create(:code=>"bp_shoulder",   :name_fr=>"Epaule");
    Bodypart.create(:code=>"bp_torso",      :name_fr=>"Torse");
    Bodypart.create(:code=>"bp_ankle",      :name_fr=>"Cheville");
    Bodypart.create(:code=>"bp_back",       :name_fr=>"Dos");
    Bodypart.create(:code=>"bp_wrist",      :name_fr=>"Poignet");
    Bodypart.create(:code=>"bp_other",      :name_fr=>"Autre");
  end
end
