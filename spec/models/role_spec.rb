# == Schema Information
#
# Table name: roles
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  code        :string(255)
#  isSystem    :boolean          default("false")
#

require 'spec_helper'

describe Role do
  pending "add some examples to (or delete) #{__FILE__}"
end
