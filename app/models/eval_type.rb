# == Schema Information
#
# Table name: eval_types
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  organization_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class EvalType < ActiveRecord::Base
  has_many :evaluations
  belongs_to :organization

  validates :name, :organization_id, presence: true
end
