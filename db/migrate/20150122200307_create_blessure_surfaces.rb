class CreateBlessureSurfaces < ActiveRecord::Migration
    def up 
        create_table :blessure_surfaces do |t|
            t.string :code
            t.string :description

            t.timestamps null: false
        end

        add_column :blessures, :blessure_surface_id, :integer

        aBlessure = BlessureSurface.new
        aBlessure.code = "sf_gym"
        aBlessure.description = "Gymnase"
        aBlessure.save
        aBlessure = BlessureSurface.new
        aBlessure.code = "sf_grasssynth"
        aBlessure.description = "Gazon Synthétique"
        aBlessure.save
        aBlessure = BlessureSurface.new
        aBlessure.code = "sf_grassnat"
        aBlessure.description = "Gazon naturel"
        aBlessure.save
        aBlessure = BlessureSurface.new
        aBlessure.code = "sf_glass"
        aBlessure.description = "Glace"
        aBlessure.save

        aBlessure = BlessureSurface.new
        aBlessure.code = "sf_other"
        aBlessure.description = "Autre"
        aBlessure.save

        Blessure.all.each do |f|
            aBlessure = BlessureSurface.find_by(:code => f.surface)
            if aBlessure != nil
                f.blessure_surface_id = aBlessure.id
                f.save
                puts "Saved Blessure operatinon for blessure id = " << f.id.to_s
            end
        end

        add_foreign_key "blessures", "blessure_surfaces", name: "blessure_blessure_surfaces_fk", column:"blessure_surface_id"
    end

    def down
        remove_foreign_key "blessures", "blessure_surfaces"
        remove_column :blessures, :blessure_surfaces_id
        drop_table :blessure_surfaces
    end
end
