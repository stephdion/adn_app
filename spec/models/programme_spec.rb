# == Schema Information
#
# Table name: programmes
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :text
#  user_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'spec_helper'

describe Programme do
  pending "add some examples to (or delete) #{__FILE__}"
end
