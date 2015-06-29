# == Schema Information
#
# Table name: exercise_categories
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  organization_id :integer
#

class ExerciseCategory < ActiveRecord::Base
  belongs_to :organization
  has_many :exercise_subcategories

  def self.get_exercise_tree
  	ExerciseCategory.where("organization_id IN (?)", [Organization.current_organization, Organization.admin_organization]).includes(exercise_subcategories: :exercises)
  end

  def self.get_exercise_categories(organization_id)
  	ExerciseCategory.where("organization_id IN (?)", organization_id).includes(exercise_subcategories: :exercises)
  end

end
