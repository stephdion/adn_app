# == Schema Information
#
# Table name: family_members
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  parent_id    :integer
#  relationship :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'spec_helper'

describe FamilyMember do
  pending "add some examples to (or delete) #{__FILE__}"
end
