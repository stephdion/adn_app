class AddAttachmentPhotoToUsers < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.attachment :photo
	  t.attachment :banner
    end
  end

  def self.down
    drop_attached_file :users, :photo, :banner
  end
end
