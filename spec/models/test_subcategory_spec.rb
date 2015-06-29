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

require 'spec_helper'

describe TestSubcategory do
  pending "add some examples to (or delete) #{__FILE__}"
end
