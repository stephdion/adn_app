class CreateBlessureOperations < ActiveRecord::Migration
  def up
    create_table :blessure_operations do |t|
      t.string :code
      t.string :description

      t.timestamps null: false
    end

    aBlessure = BlessureOperation.new
    aBlessure.code = "op_na"
    aBlessure.description = "Non applicable"
    aBlessure.save

    aBlessure = BlessureOperation.new
    aBlessure.code = "op_todo"
    aBlessure.description = "Opération prévue"
    aBlessure.save

    aBlessure = BlessureOperation.new
    aBlessure.code = "op_done"
    aBlessure.description = "Déjà operé"
    aBlessure.save

    add_column :blessures, :blessure_operation_id, :integer

    Blessure.all.each do |f|
        aBlessure = BlessureOperation.find_by(:code => f.operation)
        if aBlessure != nil
            f.blessure_operation_id = aBlessure.id
            f.save
            puts "Saved Blessure operatinon for blessure id = " << f.id.to_s
        end
    end

    add_foreign_key "blessures", "blessure_operations", name: "blessure_blessure_operations_fk", column:"blessure_operation_id"
  end

  def down
        remove_foreign_key "blessures", "blessure_operations"
        remove_column :blessures, :blessure_operation_id
        drop_table :blessure_operations
  end
end
