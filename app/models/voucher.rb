# == Schema Information
#
# Table name: vouchers
#
#  id              :integer          not null, primary key
#  token           :string(255)
#  description     :text
#  role_id         :integer
#  organization_id :integer
#  is_enabled      :boolean          default("true")
#  isSystem        :boolean          default("false")
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Voucher < ActiveRecord::Base
  belongs_to :role
  belongs_to :organization

  validates :role, presence: true
  validates :organization, presence: true
  validates :token, presence: true
end
