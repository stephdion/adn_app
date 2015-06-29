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

class Prescription < ActiveRecord::Base
    belongs_to :eval_test
    belongs_to :exercise

    default_scope { order('exercise_order ASC') }
end
