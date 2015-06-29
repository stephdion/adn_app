class CreateBlessuretypes < ActiveRecord::Migration
  def change
    create_table :blessuretypes do |t|
      t.string :name_fr,    :required=>true
      t.string :code,       :required=>true, :unique => true
      t.string :description

      t.timestamps
    end
    add_index(:blessuretypes, [:code],  :unique => true)

    Blessuretype.create(:code=>"ti_strch",      :name_fr=>"Elongation")
    Blessuretype.create(:code=>"ti_brkdown",    :name_fr=>"Claquage")
    Blessuretype.create(:code=>"ti_tear",       :name_fr=>"Dechirure")
    Blessuretype.create(:code=>"ti_break",      :name_fr=>"Rupture")
    Blessuretype.create(:code=>"ti_bursitis",   :name_fr=>"Bursite")
    Blessuretype.create(:code=>"ti_tendinitis", :name_fr=>"Tendinite")
    Blessuretype.create(:code=>"ti_cts",        :name_fr=>"Syndrome du tunnel carpien")
    Blessuretype.create(:code=>"ti_spr",        :name_fr=>"Entorse")
    Blessuretype.create(:code=>"ti_fract",      :name_fr=>"Fracture")
    Blessuretype.create(:code=>"ti_infl",       :name_fr=>"Inflammation")
    Blessuretype.create(:code=>"ti_oste",       :name_fr=>"Arthrose")
    Blessuretype.create(:code=>"ti_infct",      :name_fr=>"Infection")
    Blessuretype.create(:code=>"ti_dislc",      :name_fr=>"Dislocation")
    Blessuretype.create(:code=>"ti_luxa",       :name_fr=>"Luxation")
    Blessuretype.create(:code=>"ti_cont",       :name_fr=>"Contusion")
    Blessuretype.create(:code=>"ti_cmcrbl",     :name_fr=>"Commotion cerebrale")
    Blessuretype.create(:code=>"ti_patte",      :name_fr=>"Syndrome femoro pattellaire")
    Blessuretype.create(:code=>"ti_rotu",       :name_fr=>"Syndrome femoro-rotulien")
  end
end
