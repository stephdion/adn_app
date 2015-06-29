# == Schema Information
#
# Table name: equipes
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  description     :string(255)
#  equipe_type_id  :integer
#  user_id         :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  organization_id :integer
#

require 'spec_helper'

describe Equipe do
  pending "add some examples to (or delete) #{__FILE__}"
end
