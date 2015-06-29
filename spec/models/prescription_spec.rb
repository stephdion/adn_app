# == Schema Information
#
# Table name: prescriptions
#
#  id             :integer          not null, primary key
#  eval_test_id   :integer
#  exercise_id    :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  exercise_order :integer
#  archived       :date
#

require 'spec_helper'

describe Prescription do
  pending "add some examples to (or delete) #{__FILE__}"
end
