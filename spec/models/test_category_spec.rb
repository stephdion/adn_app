# == Schema Information
#
# Table name: test_categories
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  organization_id :integer
#

require 'spec_helper'

describe TestCategory do
  pending "add some examples to (or delete) #{__FILE__}"
end
