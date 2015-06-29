# == Schema Information
#
# Table name: scat2_concentrations
#
#  id         :integer          not null, primary key
#  code       :string(255)      not null
#  value      :integer          not null
#  scat2_id   :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Scat2Concentration < ActiveRecord::Base
  belongs_to :scat2

  validates :code, presence: true
  validates :value, presence: true
end
