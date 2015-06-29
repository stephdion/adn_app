class AddBlessureTypeFkToBlessures < ActiveRecord::Migration
  def up
    add_column :blessures, :blessure_type_id, :integer

    Blessure.all.each do |f|
        blessure_type = Blessuretype.all.find_by(:code => f.type_de_blessure)
        if blessure_type != nil
            f.blessure_type_id = blessure_type.id
            puts "Update blessure type on blessure_id = " << f.id.to_s
            f.save
        end
    end

    add_foreign_key "blessures", "blessuretypes", name: "blessures_blessuretypes_fk", column: "blessure_type_id"
  end

  def down
    remove_foreign_key "blessures", name: "blessures_blessuretypes_fk", column: "blessure_type_id"
    remove_column :blessures, :blessure_type_id
  end
end
