# == Schema Information
#
# Table name: organizations
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  code        :string(255)
#  isSystem    :boolean          default("false")
#

class Organization < ActiveRecord::Base
  belongs_to :voucher

 has_many :memberships
 accepts_nested_attributes_for :memberships, allow_destroy: true

 has_many :users, :through => :memberships
 has_many :equipes
 has_many :equipe_types
 has_many :evaluations
 has_many :eval_types
 has_many :positions
 has_many :eval_tests
 has_many :exercises
 has_many :exercise_categories
 has_many :exercise_subcategories
 has_many :test_categories
 has_many :test_subcategories
 has_many :voucher

def self.current_organization=(id)
  Thread.current[:organization_id] = id
end

def self.current_organization
  find(Thread.current[:organization_id])
end

def self.admin_organization
  return 1
end

def equipes
    Equipe.where('organization_id IN (?)', [self.id, Organization.admin_organization]).order(:name)
end

def equipe_types
    EquipeType.where('organization_id IN (?)', [self.id, Organization.admin_organization]).order(:name)
end

def evaluations
    Evaluation.where('organization_id IN (?)', [self.id, Organization.admin_organization]).order(:name)
end

def eval_types
    EvalType.where('organization_id IN (?)', [self.id, Organization.admin_organization]).order(:name)
end

def positions
    Position.where('organization_id IN (?)', [self.id, Organization.admin_organization]).order(:name)
end

def eval_tests
    EvalTest.where('organization_id IN (?)', [self.id, Organization.admin_organization]).order(:name)
end

def exercises
    Exercise.where('organization_id IN (?)', [self.id, Organization.admin_organization]).order(:name)
end

def exercise_categories
    ExerciseCategory.where('organization_id IN (?)', [self.id, Organization.admin_organization]).order(:name)
end

def exercise_subcategories
    ExerciseSubcategory.where('organization_id IN (?)', [self.id, Organization.admin_organization]).order(:name)
end

def test_categories
    TestCategory.where('organization_id IN (?)', [self.id, Organization.admin_organization]).order(:name)
end

def test_subcategories
    TestSubcategory.where('organization_id IN (?)', [self.id, Organization.admin_organization]).order(:name)
end

end
