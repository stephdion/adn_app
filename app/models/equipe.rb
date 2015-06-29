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

class Equipe < ActiveRecord::Base
  belongs_to :user
  belongs_to :organization
  has_many :participations, :dependent => :destroy
  has_many :users, :through => :participations
  belongs_to :equipe_type
  accepts_nested_attributes_for :equipe_type
  has_many :resultats
  has_many :blessure

  validates :name, presence: true
  validates :description, presence: true
  validates :equipe_type_id, presence: true

  default_scope { order('name ASC') }

  def self.in_organization
    return Organization.current_organization.equipes
  end

  def in_current_organization?
    if self.user
      return true
    else
      return false
    end
  end

  def get_members(aRoleId)
    users.joins(:memberships, :participations)
         .where('memberships.organization_id = ? 
                AND memberships.role_id = ? 
                AND participations.archived IS NULL', 
                organization_id, aRoleId).distinct

  end

  def get_all_members
    users.joins(:memberships, :participations).where('memberships.organization_id = ? AND participations.archived IS NULL', organization_id).all
  end

  def responsables
    return self.user
  end

  def participations(archives = '')
    if archives == ''
       Participation.where(:equipe_id => self.id).where(:archived => nil)
    else
       Participation.where(:equipe_id => self.id)
    end
  end

end
