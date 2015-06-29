class AddSideToBodysides < ActiveRecord::Migration
  def change
    add_column :bodyparts, :has_side, :boolean

    Bodypart.update_all(:has_side => true)
    Bodypart.all.each do |bodypart|
      if bodypart.code == 'bp_head' || bodypart.code == 'bp_neck' ||
        bodypart.code == 'bp_torso' || bodypart.code == 'bp_back' ||
        bodypart.code == 'bp_other'
        bodypart.update_attributes(:has_side => 'f')
      end
    end
    #Bodypart.where(:code => 'bd_head').update_ALL(:has_side => 'f')
  end
end
