class Update2Scat2s < ActiveRecord::Migration
  def change

    drop_table :scat2_memorys
    create_table :scat2_memories do |t|
      t.string  :code, :null=>false
      t.integer :value, :null=>false
      t.integer :scat2_id, :null=>false

      t.timestamps
    end

  end

end
