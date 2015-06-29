class RenameUserAnthropometryToUserAnthropometrics < ActiveRecord::Migration
  def up
    rename_table :user_anthropometry  , :user_anthropometrics
    add_column   :user_anthropometrics, :archive,             :boolean
    add_column   :user_anthropometrics, :archiveDate,         :date

    create_table :user_emails do |t|
      t.string  :email_type    , null: false
      t.string  :email         , null: false
      t.integer :user_id       , null: false

      t.timestamps
    end
  end

  def down
    rename_table  :user_anthropometrics, :user_anthropometry
    remove_column :user_anthropometry  , :archive
    remove_column :user_anthropometry  , :archiveDate
    drop_table    :user_emails
  end
end
