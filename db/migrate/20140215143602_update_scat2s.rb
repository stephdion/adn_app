class UpdateScat2s < ActiveRecord::Migration
  def change
    add_column :scat2s, :foot_tested,   :string
    add_column :scat2s, :hand_tested,   :string

    create_table :scat2_memorys do |t|
      t.string  :code, :null=>false
      t.integer :value, :null=>false
      t.integer :scat2_id, :null=>false

      t.timestamps
    end

    create_table :scat2_concentrations do |t|
      t.string  :code, :null=>false
      t.integer :value, :null=>false
      t.integer :scat2_id, :null=>false

      t.timestamps
    end

    create_table :scat2_cognitions do |t|
      t.string  :code, :null=>false
      t.integer :value, :null=>false
      t.integer :scat2_id, :null=>false

      t.timestamps
    end
  end

end
