class RenameMailForMailUsers < ActiveRecord::Migration
    def up
        rename_table :mails, :mail_users
    end

    def down
        rename_table :mail_users, :mails
    end
end
