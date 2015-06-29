class AddImageToTests < ActiveRecord::Migration

  def self.up
    add_attachment :eval_tests, :image
  end

  def self.down
    remove_attachment :eval_tests, :image
  end

end
