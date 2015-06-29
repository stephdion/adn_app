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
#  equipe_id             :integer
#

class Blessure < ActiveRecord::Base
  include BlessuresHelper

  belongs_to :user
  belongs_to :equipe
  belongs_to :reporter, :class_name => "User"
  belongs_to :equipe_type
  belongs_to :bodyside, :foreign_key => 'body_side_id'
  belongs_to :bodypart, :foreign_key => 'body_part_id'
  belongs_to :blessure_type, :foreign_key => 'blessure_type_id', :class_name => 'Blessuretype'
  has_many :symptomes_blessure
  has_one :blessure_operation, :foreign_key => 'blessure_operation_id'
  has_one :blessure_surface, :foreign_key => 'blessure_surface_id'
  has_one :blessure_mechanism, :foreign_key => 'blessure_mechanism_id'

  validates :user_id, presence: true
  validates :date, presence: true
  validates :equipe_id, :numericality => { :greater_than => 0, :message => "Les utilisateurs sans équipe ne peuvent pas entrer de blessure" } 

  after_initialize :init
  before_save      :before_save

  default_scope { order('date DESC') }

  def self.dashboard(participants, start_date, end_date, sport, bodypart, sex, blessuretype)
      search_string = "blessures.user_id in (?) AND date >= ? AND date <= ? AND (original_report_id = 0 OR original_report_id IS NULL)"
      if sport != nil
        search_string += " AND blessures.equipe_type_id = '" + sport.to_s + "'"
      end
      if bodypart != nil
        search_string += " AND partie_du_corp = '" + bodypart + "'"
      end
      if sex != nil
        search_string += " AND sex = '" + sex + "'"
      end
      if blessuretype != nil
        search_string += " AND type_de_blessure = '" + blessuretype + "'"
      end

      includes(:bodypart, :equipe_type, user: [:equipes, :memberships, participations: [:position]])
      .references(user: [:memberships, participations: [:position]])
      .joins(:user, :bodypart).where(search_string, participants, start_date, end_date)
  end

  def has_valid_operation?
    return self.operation!=nil && self.operation!='' && self.operation != $operation[0][1]
  end

  def has_side?
    return self.partie_du_corp_o!=nil && self.partie_du_corp_o.has_side
  end

  def title
    _title = self.date.to_s+"-"+type_de_blessure_name+"-"+partie_du_corp_name
    if self.has_valid_operation?
      _title = _title + " ["+ get_value(self.operation, $operation)+"-"+self.operation_date.to_s+"]"
    end
    return _title
  end

  def title_wo_date
    _title = type_de_blessure_name+"-"+partie_du_corp_name
    if self.has_valid_operation?
      #_title = _title + " ["+ get_value(self.operation, $operation)+"-"+self.operation_date.to_s+"]"
    end
    return _title
  end

  def index_title
    return user.to_s+' ('+title+')'
  end

   def report_title
    return user.to_s+' ('+title+')'
  end

  def partie_du_corp_o
    if !partie_du_corp.empty?
      return Bodypart.find_by_code(partie_du_corp)
    end
    return nil
  end

  def partie_du_corp_name
    if partie_du_corp!=nil && !partie_du_corp.empty?
      value = Bodypart.find_by_code(partie_du_corp)
      if value
        value_name = value.name
        cote = cote_du_corp_name
        if !cote.empty?
          value_name = value_name + " (" + cote + ")"
        end
        return value_name
      end
      return "*"+partie_du_corp+"*"
    end
    return ""
  end

  def cote_du_corp_name
    if cote_du_corp!=nil && !cote_du_corp.empty?
      value = Bodyside.find_by_code(cote_du_corp)
      if value
        return value.code == "bs_na" ? "" : value.name
      end
      return "*"+cote_du_corp+"*"
    end
    return ""
  end

  def type_de_blessure_name
    if type_de_blessure!= nil && !type_de_blessure.empty?
      value = Blessuretype.find_by_code(type_de_blessure)
      if value
        return value.name
      end
      return "*"+type_de_blessure+"*"
    end
    return ""
  end

  def symptomes
      if symptomes_data == nil
        return []
      else
        symptomes_data.split(',')
      end
  end

  def symptomes=(data)
    if !data.nil?
      self.symptomes_data = data.each { |f| f }.join ','
    end
  end

:private
  def init
    if self.new_record?
      self.date = Time.now
    end
  end

  def before_save
    if symptomes
      self.symptomes_data = symptomes.each { |f| f }.join ','
    end
    if !has_valid_operation?
      self.operation_date = nil;
    end
    if !has_side?
      self.cote_du_corp = nil;
    end
  end
end
