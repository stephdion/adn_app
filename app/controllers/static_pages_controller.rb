class StaticPagesController < ApplicationController
  include ApplicationHelper
  skip_before_filter :signed_in_user
  
  def home
  end

  def decouvrir
  end

  def avantages
  end

  def signin
  end
  
end
