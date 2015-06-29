# == Schema Information
#
# Table name: user_phones
#
#  id         :integer          not null, primary key
#  phone_type :string(255)      not null
#  number     :string(255)      not null
#  user_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class UserPhone < ActiveRecord::Base
    belongs_to :user

    validates :phone_type, presence: true, length: { maximum: 50 }
    validates :number, presence: true, length: { maximum: 50 }

    def to_s
        return phone_type.to_s() + ': '+ number.to_s;
    end
end
