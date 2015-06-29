# == Schema Information
#
# Table name: symptomes_blessures
#
#  id          :integer          not null, primary key
#  symptome_id :integer
#  blessure_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class SymptomesBlessure < ActiveRecord::Base
    belongs_to :symptome
    belongs_to :blessure

    validates :blessure_id, presence: true
    validates :symptome_id, presence: true
end
