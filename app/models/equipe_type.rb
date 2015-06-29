# == Schema Information
#
# Table name: equipe_types
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  organization_id :integer
#

class EquipeType < ActiveRecord::Base
  has_many :equipes
  has_many :positions
  belongs_to :organization

  validates :name, presence: true

  def equipe_type_and_organization
    "#{name} - #{organization.name}"
  end

end
