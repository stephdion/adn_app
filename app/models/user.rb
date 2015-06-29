# == Schema Information
#
# Table name: users
#
#  id                       :integer          not null, primary key
#  last_name                :string(255)      not null
#  email                    :string(255)
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  password_digest          :string(255)
#  remember_token           :string(255)
#  registration_token       :string(255)
#  is_enabled               :boolean          not null
#  first_name               :string(255)      not null
#  address                  :string(255)
#  city                     :string(255)
#  state                    :string(255)
#  postalCode               :string(255)
#  country                  :string(255)
#  birthday                 :date
#  sex                      :string(255)
#  change_password_required :boolean          default("false"), not null
#  photo_file_name          :string(255)
#  photo_content_type       :string(255)
#  photo_file_size          :integer
#  photo_updated_at         :datetime
#  banner_content_type      :string(255)
#  banner_file_size         :integer
#  banner_file_name         :string(255)
#  banner_updated_at        :datetime
#  user_phones_count        :integer          default("0"), not null
#

class User < ActiveRecord::Base
  has_secure_password
  has_many :eval_tests
  has_many :exercises
  has_many :evaluations
  has_many :programmes
  has_many :blessures
  has_many :scat2s, -> { order('scat2s.evaluation_datetime') }
  has_many :admin_equipes, class_name: "Equipe"


  has_many :user_phones
  accepts_nested_attributes_for :user_phones, allow_destroy: true

  has_many :user_emails
  accepts_nested_attributes_for :user_emails, allow_destroy: true

  has_many :user_anthropometrics
  accepts_nested_attributes_for :user_anthropometrics, allow_destroy: true

  has_many :memberships
  accepts_nested_attributes_for :memberships, :reject_if => proc { |attributes| attributes.any? {|k,v| v.blank?} }
  has_many :organizations, :through => :memberships
  has_many :roles, :through => :memberships

  has_many :participations, :dependent => :destroy
  has_many :equipes, :through => :participations
  has_many :resultats

  has_many :family_members
  accepts_nested_attributes_for :family_members, allow_destroy: true
  has_many :parents, :through => :family_members
  has_many :child_links, :class_name => "FamilyMember", :foreign_key => "parent_id"
  has_many :children, :through => :child_links, :source => :user

  has_attached_file :photo, styles: { thumbnail: '50x50#', medium: '125x125>', large: '400x400>'},
                    :default_url => "https://s3.amazonaws.com/solutionADN/users/Default_user_image/Default_:style.jpg"
  validates_attachment_size :photo, :less_than => 5.megabytes
  validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png', 'image/gif', 'image/bmp']

  has_attached_file :banner, styles: { large: '750x300'},
                    :default_url => "https://s3.amazonaws.com/solutionADN/users/Default_user_banner/Default_:style.jpg"
  validates_attachment_size :banner, :less_than => 5.megabytes
  validates_attachment_content_type :banner, :content_type => ['image/jpeg', 'image/png', 'image/gif', 'image/bmp']

  before_save { |user| user.email = email.downcase }
  before_save :create_remember_token

  validates :first_name, presence: true, length: { maximum: 25 }
  validates :last_name, presence: true, length: { maximum: 25 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence:   true,
                     format:     { with: VALID_EMAIL_REGEX },
                     uniqueness: { case_sensitive: false }
  validates :password              , presence: true, length: { minimum: 6 }, :if=>:validate_password?
  validates :password_confirmation , presence: true                        , :if=>:validate_password?
  after_validation { self.errors.messages.delete(:password_digest) }

#  default_scope { order('last_name ASC') }

  def to_s
    return first_name.to_s() + ' '+ last_name.to_s();
  end

  def name
    return to_s
  end

  def age
  if birthday
    now = Time.now.utc.to_date
    return now.year - birthday.year - (birthday.to_date.change(:year => now.year) > now ? 1 : 0)
	end
  end

  def index_item
    return last_name.to_s() + ' '+ first_name.to_s();
  end

  def validate_password?
    password.present? || password_confirmation.present?
  end

  def hasAnthropometrics?
    return user_anthropometrics.select { |a| a.archive==false }.length>0
    #if nonArchive.length==0
  end

  def self.search(search)
    search_condition = "%" + search.downcase + "%"
    User.where('(lower(first_name) LIKE ? OR lower(last_name) LIKE ?) AND deleted = 0', search_condition, search_condition)
  end

  def current_role
    membership = Membership.where(:user_id => id, :organization_id => Organization.current_organization).first
    if membership
      return membership.role
    else
      return Role.find_or_create_by(name: "Aucun", code: "NONE")
    end
  end

  def adn_sysadmin?
    membership = Membership.where(:user_id => id, :organization_id => Organization.admin_organization, :role_id => Role.where(:code => "SYSADM").first.id)
    if membership.any?
      return true
    else
      return false
    end
  end

  def is_temporary?
    I18n.available_locales.each do |locale|
      I18n.locale = locale
        begin
          tempdom = I18n.translate('user_temp_email', :raise => false)
          if !email.empty? and email.end_with?  tempdom
            return true
          end
        end
    end
    return false
  end

  def has_address?
    return address && !address.empty?
  end

  def has_phones?
    return user_phones.length>0
  end

  def last_scat2s
    return scat2s.drop([scat2s.length-4, 0].max)
  end

  def self.in_organization(role_code_array, org_id = Organization.current_organization)
    if role_code_array.first == "ALL"
      where(:deleted=>0).joins(:memberships).where("memberships.organization_id = ?", org_id)
    else
      role_array = Array.new
      include_adn_sysadm = false
      role_code_array.each do |role_code|
        if role_code == "ADN_SYSADM"
          include_adn_sysadm = true
        else
          role_array << Role.where(:code => role_code).first.id
        end
      end
      if include_adn_sysadm == true
        return where(:deleted=>0).joins(:memberships).where("(memberships.organization_id = ? AND memberships.role_id IN (?)) OR (memberships.organization_id = ? AND memberships.role_id = ?)",
                                       org_id, role_array, Organization.admin_organization, Role.sysadm_role)
      else
        return where(:deleted=>0).joins(:memberships).where("memberships.organization_id = ? AND memberships.role_id IN (?)", org_id, role_array).distinct
      end
    end
  end

  def self.adn_sysadmins
    where(:deleted=>0).joins(:memberships).where("memberships.organization_id = ? AND memberships.role_id = ?", Organization.admin_organization, Role.sysadm_role)
  end

  def self.no_organization
    where(:deleted=>0).joins(:memberships).where("memberships.organization_id IS NULL")
  end

  def self.deleted_user
    where(:deleted=>1).joins(:memberships).where("memberships.organization_id = ?", Organization.current_organization)
  end

  def physios
    physios = Array.new
    self.equipes.each do |equipe|
      physios = physios | equipe.get_members(Role.physio_role)
    end
    if physios.include?(self)
      physios.delete(self)
    end
    return physios
  end

  def organizations
    if self.adn_sysadmin?
      return Organization.all
    else
      return super
    end
  end

  def trainers
    trainers = Array.new
    self.equipes.each do |equipe|
      trainers = trainers | equipe.get_members(Role.trainer_role)
    end
    if trainers.include?(self)
      trainers.delete(self)
    end
    return trainers
  end

  def responsables
    responsables = Array.new
    self.equipes.each do |equipe|
      responsables = responsables << equipe.user
    end
    if responsables.include?(self)
      responsables.delete(self)
    end
    return responsables
  end

  def directors
    directors = Array.new
    self.organizations.each do |org|
      directors = directors | User.in_organization(["DIR"], org.id).to_a
    end
    if directors.include?(self)
      directors.delete(self)
    end
    return directors
  end

  def athletes
    athletes = Array.new
    self.organizations.each do |org|
      athletes = athletes | User.in_organization(["ATHLETE"], org.id).to_a
    end
    if athletes.include?(self)
      athletes.delete(self)
    end
    return athletes
  end

  def parents
    parents = Array.new
    self.organizations.each do |org|
      parents = parents | User.in_organization(["PARENT"], org.id).to_a
    end
    if parents.include?(self)
      parents.delete(self)
    end
    return parents
  end

  def sysadmins
    sysadmins = Array.new
    self.organizations.each do |org|
      sysadmins = sysadmins | User.in_organization(["SYSADM"], org.id).to_a
    end
    if sysadmins.include?(self)
      sysadmins.delete(self)
    end
    return sysadmins
  end

  def s_to_date(dateStr)
    return dateStr!=nil ? DateTime.strptime(dateStr, "%Y-%m-%d %H:%M") : nil
  end

  def current_team_members
    admin_equipes = Equipe.where(:user_id => self.id)
    all_teams = admin_equipes | self.equipes
    all_team_members = User.where("participations.equipe_id IN (?) AND participations.archived IS NULL AND memberships.organization_id = ? AND deleted=0", all_teams.to_a.map(&:id), Organization.current_organization)
    athletes = all_team_members.joins(:participations, :memberships).where("memberships.role_id = ?", Role.athlete_role.id)
    return athletes
  end

  def blessures
    Blessure.where("user_id IN (?) AND (original_report_id = 0 OR original_report_id IS NULL)", self.id)
  end

  private
    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
end
