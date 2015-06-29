# == Schema Information
#
# Table name: user_anthropometrics
#
#  id          :integer          not null, primary key
#  height      :integer
#  weight      :integer
#  user_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  archive     :boolean
#  archiveDate :date
#

class UserAnthropometric < ActiveRecord::Base
  belongs_to :user

  before_validation :update_archive_date

  def update_archive_date
    if archive_changed? && archive
      currentTime = Time.new
      self[:archiveDate] = Date.new(currentTime.year, currentTime.month, currentTime.day)
    end
  end

  def height_imperial
    if height
      feet = height / 2.54 / 12
      inch = (height / 2.54) % 12
      return feet.floor.to_s + '\' ' + inch.floor.to_s + '"'
    else
      return "N/A"
    end
  end

  def to_s
    return 'weight: ' + weight.to_s + 'kg / height: ' + height.to_s;
  end
end
