# == Schema Information
#
# Table name: memberships
#
#  id              :integer          not null, primary key
#  user_id         :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  organization_id :integer
#  role_id         :integer
#  archived        :date
#  year_since_join :date
#

require 'spec_helper'

describe Membership do
  pending "add some examples to (or delete) #{__FILE__}"
end
