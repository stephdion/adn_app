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

require 'spec_helper'

describe Voucher do
  pending "add some examples to (or delete) #{__FILE__}"
end
