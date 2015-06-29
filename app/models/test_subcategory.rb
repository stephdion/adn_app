# == Schema Information
#
# Table name: test_subcategories
#
#  id               :integer          not null, primary key
#  name             :string(255)
#  test_category_id :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  organization_id  :integer
#

class TestSubcategory < ActiveRecord::Base
  belongs_to :test_category
  belongs_to :organization
  has_many :eval_tests
end
