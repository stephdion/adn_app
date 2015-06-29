# == Schema Information
#
# Table name: programmes
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :text
#  user_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Programme < ActiveRecord::Base
  belongs_to :user
  has_many :exercise_sets, :dependent => :destroy
  has_many :exercises, :through => :exercise_sets

  validates :user_id, presence: true
  validates :name, presence: true
  validates :description, presence: true, length: { maximum: 4000 }
end
