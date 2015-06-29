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

class Symptome < ActiveRecord::Base
    has_many :symptomes_blessures
end
