class AddImageToExercises < ActiveRecord::Migration
  def self.up
    add_attachment :exercises, :image
  end

  def self.down
    remove_attachment :exercises, :image
  end
end
