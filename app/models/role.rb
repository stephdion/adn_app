# == Schema Information
#
# Table name: roles
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  code        :string(255)
#  isSystem    :boolean          default("false")
#

class Role < ActiveRecord::Base
  has_many :voucher
  has_many :memberships


  def self.get_role_id(code)
  where(:code => code).first.id
  end

  def self.athlete_role
    where(:code => "ATHLETE").first
  end

  def self.physio_role
    where(:code => "PHYSIO").first
  end

  def self.trainer_role
    where(:code => "TRAINER").first
  end

  def self.parent_role
    where(:code => "PARENT").first
  end

  def self.sysadm_role
    where(:code => "SYSADM").first
  end

  def self.dir_role
    where(:code => "DIR").first
  end

end
