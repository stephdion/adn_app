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

require 'spec_helper'

describe ExerciseSubcategory do
  pending "add some examples to (or delete) #{__FILE__}"
end
