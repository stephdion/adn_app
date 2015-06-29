# == Schema Information
#
# Table name: blessure_surfaces
#
#  id          :integer          not null, primary key
#  code        :string
#  description :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class BlessureSurface < ActiveRecord::Base
    belongs_to :blessure
end
