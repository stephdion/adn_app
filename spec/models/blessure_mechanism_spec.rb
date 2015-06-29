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

require 'rails_helper'

RSpec.describe BlessureMechanism, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
