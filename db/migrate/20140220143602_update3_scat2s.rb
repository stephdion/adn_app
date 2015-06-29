class Update3Scat2s < ActiveRecord::Migration
  def change
    add_column :scat2s, :symptoms_worst_physical, :int
    add_column :scat2s, :symptoms_worst_mental,   :int
    add_column :scat2s, :global_estimation,       :string
  end

end
