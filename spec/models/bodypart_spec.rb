# == Schema Information
#
# Table name: bodyparts
#
#  id          :integer          not null, primary key
#  name_fr     :string(255)
#  code        :string(255)
#  description :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  has_side    :boolean
#

require 'spec_helper'

describe Bodypart do
  pending "add some examples to (or delete) #{__FILE__}"
end
