class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string  :nom
      t.string  :organization
      t.string  :prenom
      t.string  :user_type
      t.string  :email
      t.string  :telephone
      t.string  :other
      t.boolean :archive
      t.boolean :receive_news

      t.timestamps
    end
  end
end
