# == Schema Information
#
# Table name: blessure_operations
#
#  id          :integer          not null, primary key
#  code        :string
#  description :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class BlessureOperation < ActiveRecord::Base
    belongs_to :blessures
end
