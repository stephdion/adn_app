# == Schema Information
#
# Table name: blessures
#
#  id                    :integer          not null, primary key
#  user_id               :integer          not null
#  partie_du_corp        :string(255)
#  cote_du_corp          :string(255)
#  type_de_blessure      :string(255)
#  mechanism             :string(255)
#  surface               :string(255)
#  retour_au_jeu         :boolean
#  symptomes_data        :string(255)
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  date                  :date             default("2013-09-27"), not null
#  equipe_type_id        :integer
#  operation             :string(255)
#  detail                :string(255)
#  operation_date        :date
#  original_report_id    :integer
#  reporter_id           :integer
#  body_part_id          :integer
#  body_side_id          :integer
#  blessure_type_id      :integer
#  blessure_surface_id   :integer
#  blessure_operation_id :integer
#  blessure_mechanism_id :integer
#

require 'spec_helper'

describe Blessure do
  pending "add some examples to (or delete) #{__FILE__}"
end
