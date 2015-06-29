# == Schema Information
#
# Table name: participations
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  equipe_id   :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  position_id :integer
#  archived    :date
#

require 'spec_helper'

describe Participation do
  pending "add some examples to (or delete) #{__FILE__}"
end
