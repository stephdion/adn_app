class AddBodyPartsIdAndBodySideIdToBlessures < ActiveRecord::Migration
    def up
        add_column :blessures, :body_part_id, :integer
        add_column :blessures, :body_side_id, :integer

        Blessure.all.each do |f|
            body_part = Bodypart.all.find_by(:code => f.partie_du_corp)
            if body_part != nil
                f.body_part_id = body_part.id
            end

            body_side = Bodyside.all.find_by(:code => f.cote_du_corp)
            if body_side != nil
                f.body_side_id = body_side.id
            end

            if body_side != nil || body_part != nil
                puts "Updating body parts and body side attributes on blessure_id = " << f.id.to_s
                f.save
            end
        end

        add_foreign_key "blessures", "bodyparts", name: "blessures_body_part_fk", column: "body_part_id"
        add_foreign_key "blessures", "bodysides", name: "blessures_body_side_fk", column: "body_side_id"
    end

    def down
        remove_foreign_key "blessures", name: "blessures_body_part_fk", column: "body_part_id"
        remove_foreign_key "blessures", name: "blessures_body_side_fk", column: "body_side_id"
        remove_column :blessures, :body_part_id
        remove_column :blessures, :body_side_id
    end

end
