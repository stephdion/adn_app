class AddOperationdateToBlessure < ActiveRecord::Migration
  def change
    add_column :blessures, :operation_date, :date
    change_table :blessures do |t|
      t.change :date, :date
    end
  end
end
