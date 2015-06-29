# == Schema Information
#
# Table name: blessure_mechanisms
#
#  id          :integer          not null, primary key
#  code        :string
#  description :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class BlessureMechanism < ActiveRecord::Base
    belongs_to :blessure
end
