class CreateTestSubcategories < ActiveRecord::Migration
  def change
    create_table :test_subcategories do |t|
      t.string :name
      t.integer :test_category_id

      t.timestamps
    end
  end
end
