# == Schema Information
#
# Table name: exercises
#
#  id                      :integer          not null, primary key
#  name                    :string(255)
#  description             :text
#  user_id                 :integer
#  video                   :string(255)
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  image_file_name         :string(255)
#  image_content_type      :string(255)
#  image_file_size         :integer
#  image_updated_at        :datetime
#  short_desc              :string(255)
#  short_name              :string(255)
#  exercise_subcategory_id :integer
#  organization_id         :integer
#

class Exercise < ActiveRecord::Base
  belongs_to :user
  belongs_to :exercise_subcategory
  belongs_to :organization

  has_many :prescriptions, :dependent => :destroy
  has_many :eval_tests, :through => :prescriptions
  has_many :exercise_sets, :dependent => :destroy
  has_many :programmes, :through => :exercise_set

  validates :user_id, presence: true
  validates :name, presence: true
  validates :description, presence: true, length: { maximum: 2000 }
  validates :short_name, length: { maximum: 10 }

  has_attached_file :image, styles: { thumbnail: '50x50#', medium: '125x125>', large: '400x400>'}
  validates_attachment_presence :image
  validates_attachment_size :image, :less_than => 5.megabytes
  validates_attachment_content_type :image, :content_type => ['image/jpeg', 'image/png', 'image/gif', 'image/bmp']


  default_scope { order('exercises.name ASC') }

end
