# == Schema Information
#
# Table name: bodyparts
#
#  id          :integer          not null, primary key
#  name_fr     :string(255)
#  code        :string(255)
#  description :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  has_side    :boolean
#

class Bodypart < ActiveRecord::Base
  validates :code, presence: true
  has_many :blessures

  def self.has_translation(*attributes)
    attributes.each do |attribute|
      define_method "#{attribute}" do
        self.send "name_fr"#"#{attribute}_#{I18n.locale}"
      end
    end
  end

  has_translation :name, :whatever

  def index_title
    return name.to_s+' ('+code+')'
  end
end
