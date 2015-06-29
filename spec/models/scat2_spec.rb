# == Schema Information
#
# Table name: scat2s
#
#  id                          :integer          not null, primary key
#  user_id                     :integer          not null
#  equipe_type_id              :integer          not null
#  incident_datetime           :datetime         not null
#  evaluation_datetime         :datetime         not null
#  owner_id                    :integer          not null
#  symptoms_physical           :integer
#  symptoms_mental             :integer
#  behaviour_change            :string(255)
#  unconsciousness             :integer
#  unconsciousness_time        :integer
#  balance_problem             :integer
#  glasgow_eye                 :integer
#  glasgow_verbal              :integer
#  glasgow_mouvement           :integer
#  maddocks_state              :integer
#  maddocks_half_time          :integer
#  maddocks_last_goal          :integer
#  maddocks_last_team          :integer
#  maddocks_last_win           :integer
#  cognitive_month             :integer
#  cognitive_date              :integer
#  cognitive_day               :integer
#  cognitive_year              :integer
#  cognitive_hrs               :integer
#  concentration_inverse_month :integer
#  stability_two_feet          :integer
#  stability_one_foot          :integer
#  stability_feet_aligned      :integer
#  coordination                :integer
#  cognition_differed_memory   :integer
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  foot_tested                 :string(255)
#  hand_tested                 :string(255)
#  symptoms_worst_physical     :integer
#  symptoms_worst_mental       :integer
#  global_estimation           :string(255)
#  return_to_competition       :string(255)
#

require 'spec_helper'

describe Scat2 do
  pending "add some examples to (or delete) #{__FILE__}"
end
