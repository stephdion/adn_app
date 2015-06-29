# == Schema Information
#
# Table name: user_emails
#
#  id         :integer          not null, primary key
#  email_type :string(255)      not null
#  email      :string(255)      not null
#  user_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class UserEmail < ActiveRecord::Base
    belongs_to :user

    validates :email_type, presence: true, length: { maximum: 50 }
    validates :email     , presence: true, length: { maximum: 50 }

    def to_s
        return email.to_s;
    end
end
