# == Schema Information
#
# Table name: eval_tests
#
#  id                  :integer          not null, primary key
#  name                :string(255)
#  description         :text
#  user_id             :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  image_file_name     :string(255)
#  image_content_type  :string(255)
#  image_file_size     :integer
#  image_updated_at    :datetime
#  video               :string(255)
#  short_name          :string(255)
#  component           :boolean
#  left_right          :boolean
#  test_subcategory_id :integer
#  organization_id     :integer
#

class EvalTest < ActiveRecord::Base
  belongs_to :user
  belongs_to :test_subcategory
  belongs_to :organization

  has_many :prescriptions, :dependent => :destroy
  has_many :exercises, :through => :prescriptions
  has_many :test_sets, :dependent => :destroy
  has_many :evaluations, :through => :test_sets
  has_many :resultats

  validates :user_id, presence: true
  validates :name, presence: true
  validates :description, presence: true, length: { maximum: 2000 }
  validates :short_name, presence: true, length: { maximum: 10 }, uniqueness: { case_sensitive: false }

  has_attached_file :image, styles: { thumbnail: '50x50#', medium: '125x125>', large: '400x400>'}
  validates_attachment_presence :image
  validates_attachment_size :image, :less_than => 5.megabytes
  validates_attachment_content_type :image, :content_type => ['image/jpeg', 'image/png', 'image/gif', 'image/bmp']
end
