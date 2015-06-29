class CreateSymptomesBlessures < ActiveRecord::Migration
    def up
        create_table :symptomes_blessures do |t|
            t.integer :symptome_id
            t.integer :blessure_id
            t.timestamps null: false
        end


        Blessure.all.each do |f|
            if !f.symptomes_data.nil?
                data = f.symptomes_data.split(',')
                data.each do |dataToInsert|
                    symptomeObj = Symptome.find_by(:code => dataToInsert)
                    if symptomeObj != nil
                        aSymptomeBlessure = SymptomesBlessure.new
                        aSymptomeBlessure.blessure_id = f.id
                        aSymptomeBlessure.symptome_id = symptomeObj.id
                        aSymptomeBlessure.save
                        puts "Savings a symptome blessure on blessure id = " <<
                                aSymptomeBlessure.blessure_id.to_s <<
                                " and symptome id = " << aSymptomeBlessure.symptome_id.to_s
                    end
                end
            end
        end

        add_foreign_key "symptomes_blessures", "blessures", name: "symptomesblessures_blessures_fk", column: "blessure_id"
        add_foreign_key "symptomes_blessures", "symptomes", name: "symptomesblessures_symptomes_fk", column: "symptome_id"
    end

    def down
        remove_foreign_key "symptomes_blessures", "blessures"
        remove_foreign_key "symptomes_blessures", "symptomes"
        drop_table :symptomes_blessures
    end
end
