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

class ExerciseSet < ActiveRecord::Base
  belongs_to :exercise
  belongs_to :programme
end
