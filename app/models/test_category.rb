# == Schema Information
#
# Table name: test_categories
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  organization_id :integer
#

class TestCategory < ActiveRecord::Base
  has_many :test_subcategories
  belongs_to :organization

  def self.get_test_tree
  	TestCategory.where("organization_id IN (?)", [Organization.current_organization, Organization.admin_organization]).includes(test_subcategories: :eval_tests)
  end

  def self.get_test_categories(organization_id)
  	TestCategory.where("organization_id IN (?)", organization_id).includes(test_subcategories: :eval_tests)
  end

end
