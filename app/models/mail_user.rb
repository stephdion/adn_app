# == Schema Information
#
# Table name: mail_users
#
#  id           :integer          not null, primary key
#  uid_from     :integer
#  uid_to       :integer
#  message      :text
#  subject      :string(255)
#  deleted      :integer          default("0")
#  read         :integer          default("0")
#  date_created :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class MailUser < ActiveRecord::Base

end
