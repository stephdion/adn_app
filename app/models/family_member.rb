# == Schema Information
#
# Table name: family_members
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  parent_id    :integer
#  relationship :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class FamilyMember < ActiveRecord::Base
  belongs_to :user
  belongs_to :parent, :class_name => "User"
end
