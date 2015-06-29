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

require 'spec_helper'

describe Exercise do
  pending "add some examples to (or delete) #{__FILE__}"
end
