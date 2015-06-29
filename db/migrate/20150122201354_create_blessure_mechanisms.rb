class CreateBlessureMechanisms < ActiveRecord::Migration
    def up
        create_table :blessure_mechanisms do |t|
            t.string :code
            t.string :description

            t.timestamps null: false
        end
        add_column :blessures, :blessure_mechanism_id, :integer

        aBlessure = BlessureMechanism.new
        aBlessure.code = "mch_dirch"
        aBlessure.description = "Changement de direction"
        aBlessure.save

        aBlessure = BlessureMechanism.new
        aBlessure.code = "mch_ctc"
        aBlessure.description = "Contact avec un autre joueur"
        aBlessure.save

        aBlessure = BlessureMechanism.new
        aBlessure.code = "mch_noctc"
        aBlessure.description = "Sans contact"
        aBlessure.save

        aBlessure = BlessureMechanism.new
        aBlessure.code = "mch_rcp"
        aBlessure.description = "Reception d'un sauts"
        aBlessure.save

        aBlessure = BlessureMechanism.new
        aBlessure.code = "mch_cht"
        aBlessure.description = "Chute"
        aBlessure.save

        aBlessure = BlessureMechanism.new
        aBlessure.code = "mch_cnt_bd"
        aBlessure.description = "Contact contre la bande"
        aBlessure.save

        Blessure.all.each do |f|
            aBlessure = BlessureMechanism.find_by(:code => f.mechanism)
            if aBlessure != nil
                f.blessure_mechanism_id = aBlessure.id
                f.save
                puts "Saved Blessure mechanism for blessure id = " << f.id.to_s
            end
        end

        add_foreign_key "blessures", "blessure_mechanisms", name: "blessure_blessure_mechanisms_fk", column: "blessure_mechanism_id"

    end

    def down
        remove_foreign_key "blessures", "blessure_mechanisms"
        remove_column :blessures, :blessure_mechanism_id
        drop_table :blessure_mechanisms
    end
end
