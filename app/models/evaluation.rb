# == Schema Information
#
# Table name: evaluations
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  description     :text
#  user_id         :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  point_desc0     :string(255)
#  point_desc1     :string(255)
#  point_desc2     :string(255)
#  point_desc3     :string(255)
#  eval_type_id    :integer
#  organization_id :integer
#  point_presc0    :string(255)
#  point_presc1    :string(255)
#  point_presc2    :string(255)
#  point_presc3    :string(255)
#

class Evaluation < ActiveRecord::Base
  belongs_to :user
  belongs_to :eval_type
  belongs_to :organization
  has_many :test_sets, :dependent => :destroy
  has_many :eval_tests, :through => :test_sets
  accepts_nested_attributes_for :eval_tests, :allow_destroy => true
  has_many :resultats

  validates :user_id, presence: true
  validates :name, presence: true
  validates :description, presence: true, length: { maximum: 4000 }
  validates :point_desc0, presence: true, length: { maximum: 75 }
  validates :point_desc1, presence: true, length: { maximum: 75 }
  validates :point_desc2, presence: true, length: { maximum: 75 }
  validates :point_desc3, presence: true, length: { maximum: 75 }

  def maximum_score
    max_score = 0
    self.eval_tests.each do |eval_test|
      if !eval_test.component
        max_score += 3
        if eval_test.left_right
        max_score += 3
        end
      end
    end
    return max_score
  end

  def maximum_differential
    max_differential = 0
    self.eval_tests.each do |eval_test|
      if !eval_test.component && eval_test.left_right
        max_differential += 2
      end
    end
    return max_differential
  end

  def any_exercises?
    exercises = 0
    self.eval_tests.each do |test|
     exercises += test.exercises.count
    end
    if exercises == 0
      return false
    else
      return true
    end
  end

  def get_all_exercices
    return self.eval_tests
  end

  def get_all_test_name_by_id
    json_names = []
    self.eval_tests.each do |resultat|
      puts resultat.short_name
      json_names << resultat.short_name
    end

    return json_names
  end

end
