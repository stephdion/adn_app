# == Schema Information
#
# Table name: memberships
#
#  id              :integer          not null, primary key
#  user_id         :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  organization_id :integer
#  role_id         :integer
#  archived        :date
#  year_since_join :date
#

class Membership < ActiveRecord::Base
  belongs_to :user
  belongs_to :organization
  belongs_to :role

  validates :role_id, presence: true
  validates :organization_id, presence: true

  def to_s
    return Organization.find(organization_id).name + ': '+ Role.find(role_id).name;
  end
  
  def getName
    return Role.find(role_id).name;
  end
end
