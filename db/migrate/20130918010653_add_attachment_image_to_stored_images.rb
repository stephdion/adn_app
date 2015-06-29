class AddAttachmentImageToStoredImages < ActiveRecord::Migration
  def self.up
    change_table :stored_images do |t|
      t.attachment :image
    end
  end

  def self.down
    drop_attached_file :stored_images, :image
  end
end
