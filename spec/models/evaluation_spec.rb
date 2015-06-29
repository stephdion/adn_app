# == Schema Information
#
# Table name: evaluations
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  description     :text
#  user_id         :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  point_desc0     :string(255)
#  point_desc1     :string(255)
#  point_desc2     :string(255)
#  point_desc3     :string(255)
#  eval_type_id    :integer
#  organization_id :integer
#  point_presc0    :string(255)
#  point_presc1    :string(255)
#  point_presc2    :string(255)
#  point_presc3    :string(255)
#

require 'spec_helper'

describe Evaluation do
  pending "add some examples to (or delete) #{__FILE__}"
end
