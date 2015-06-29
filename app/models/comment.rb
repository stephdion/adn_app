# == Schema Information
#
# Table name: comments
#
#  id           :integer          not null, primary key
#  nom          :string(255)
#  organization :string(255)
#  prenom       :string(255)
#  user_type    :string(255)
#  email        :string(255)
#  telephone    :string(255)
#  other        :string(255)
#  archive      :boolean
#  receive_news :boolean
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Comment < ActiveRecord::Base
  def index_item
    return nom.to_s() + ' '+ prenom.to_s()+' - '+email.to_s();
  end

end
