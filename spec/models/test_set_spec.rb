# == Schema Information
#
# Table name: test_sets
#
#  id             :integer          not null, primary key
#  eval_test_id   :integer
#  evaluation_id  :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  test_order     :integer
#  exercise_order :integer
#  archived       :date
#

require 'spec_helper'

describe TestSet do
  pending "add some examples to (or delete) #{__FILE__}"
end
