class AddUserPhonesToUser < ActiveRecord::Migration
    def self.up
        add_column :users, :user_phones_count, :integer, null:false, default: 0
        User.reset_column_information
        User.all.each do |c|
            c.update_attribute :user_phones_count, c.user_phones.length
        end
    end

    def self.down
        remove_column :users, :user_phones_count
    end
end
