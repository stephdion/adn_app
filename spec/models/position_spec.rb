# == Schema Information
#
# Table name: positions
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  equipe_type_id  :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  organization_id :integer
#

require 'spec_helper'

describe Position do
  pending "add some examples to (or delete) #{__FILE__}"
end
