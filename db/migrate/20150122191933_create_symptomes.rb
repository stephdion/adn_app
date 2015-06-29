class CreateSymptomes < ActiveRecord::Migration
    def up
        create_table :symptomes do |t|
            t.string :code
            t.string :string
            t.string :description
            t.timestamps null: false
        end

        aSymptome = Symptome.new
        aSymptome.code = 'sp_saign'
        aSymptome.description = 'Saignement'
        aSymptome.save
        aSymptome = Symptome.new
        aSymptome.code = 'sp_visem'
        aSymptome.description = 'Vision embrouillé'
        aSymptome.save
        aSymptome = Symptome.new
        aSymptome.code = 'sp_ecc'
        aSymptome.description = 'Ecchymose'
        aSymptome.save
        aSymptome = Symptome.new
        aSymptome.code = 'sp_crp'
        aSymptome.description = 'Crampe'
        aSymptome.save
        aSymptome = Symptome.new
        aSymptome.code = 'sp_etour'
        aSymptome.description = 'Étourdissement'
        aSymptome.save
        aSymptome = Symptome.new
        aSymptome.code = 'sp_fevr'
        aSymptome.description = 'Fièvre'
        aSymptome.save
        aSymptome = Symptome.new
        aSymptome.code = 'sp_head'
        aSymptome.description = 'Mal de tete'
        aSymptome.save
        aSymptome = Symptome.new
        aSymptome.code = 'sp_dlprof'
        aSymptome.description = 'Douleur profonde'
        aSymptome.save
        aSymptome = Symptome.new
        aSymptome.code = 'sp_dlart'
        aSymptome.description = 'Douleur articulaire'
        aSymptome.save
        aSymptome = Symptome.new
        aSymptome.code = 'sp_dlmusc'
        aSymptome.description = 'Douleur musculaire'
        aSymptome.save
        aSymptome = Symptome.new
        aSymptome.code = 'sp_dltend'
        aSymptome.description = 'Douleur tendineuse'
        aSymptome.save
        aSymptome = Symptome.new
        aSymptome.code = 'sp_enfl'
        aSymptome.description = 'Enflure'
        aSymptome.save
        aSymptome = Symptome.new
        aSymptome.code = 'sp_infl'
        aSymptome.description = 'Inflammation'
        aSymptome.save
        aSymptome = Symptome.new
        aSymptome.code = 'sp_other'
        aSymptome.description = 'Autre'
        aSymptome.save
    end

    def down
        drop_table :symptomes
    end
end
