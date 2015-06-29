# == Schema Information
#
# Table name: symptomes_blessures
#
#  id          :integer          not null, primary key
#  symptome_id :integer
#  blessure_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'rails_helper'

RSpec.describe SymptomesBlessure, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
