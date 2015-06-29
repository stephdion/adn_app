# == Schema Information
#
# Table name: exercise_subcategories
#
#  id                   :integer          not null, primary key
#  name                 :string(255)
#  exercise_category_id :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  organization_id      :integer
#

class ExerciseSubcategory < ActiveRecord::Base
  belongs_to :exercise_category
  belongs_to :organization

  has_many :exercises
end
