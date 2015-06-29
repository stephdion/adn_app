# == Schema Information
#
# Table name: symptomes
#
#  id          :integer          not null, primary key
#  code        :string
#  string      :string
#  description :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'rails_helper'

RSpec.describe Symptome, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
