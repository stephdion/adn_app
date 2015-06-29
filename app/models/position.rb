# == Schema Information
#
# Table name: positions
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  equipe_type_id  :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  organization_id :integer
#

class Position < ActiveRecord::Base
  belongs_to :equipe_type
  belongs_to :organization
  has_many :participations

  validates :name, presence: true, :allow_blank => false, :allow_nil => false

end

