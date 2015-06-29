# == Schema Information
#
# Table name: resultats
#
#  id            :integer          not null, primary key
#  user_id       :integer
#  equipe_id     :integer
#  athlete_id    :integer
#  evaluation_id :integer
#  eval_test_id  :integer
#  value         :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  contacted     :boolean
#  component     :integer
#  left_side     :integer
#

require 'spec_helper'

describe Resultat do
  pending "add some examples to (or delete) #{__FILE__}"
end
