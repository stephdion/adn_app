class CreateTestCategories < ActiveRecord::Migration
  def change
    create_table :test_categories do |t|
      t.string :name

      t.timestamps
    end
  end
end
