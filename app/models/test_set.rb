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

class TestSet < ActiveRecord::Base
  belongs_to :eval_test
  belongs_to :evaluation

  default_scope { order('test_order ASC') }

end
