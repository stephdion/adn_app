class CreateEvaluationTypes < ActiveRecord::Migration
  def change
    create_table :eval_types do |t|
      t.string :name
      t.integer :organization_id

      t.timestamps
    end
  end
end
