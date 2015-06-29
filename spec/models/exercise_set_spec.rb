# == Schema Information
#
# Table name: exercise_sets
#
#  id           :integer          not null, primary key
#  exercise_id  :integer
#  programme_id :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  archived     :date
#

require 'spec_helper'

describe ExerciseSet do
  pending "add some examples to (or delete) #{__FILE__}"
end
