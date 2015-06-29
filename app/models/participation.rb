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

class Participation < ActiveRecord::Base
    belongs_to :user
    belongs_to :equipe
    belongs_to :position

    def self.equipe_participants(equipe_id)
        participants = Array.new
        where("equipe_id IN (?)", equipe_id).all.each do |participant|
            participants << participant.user.id  
        end

        return participants
    end
end
