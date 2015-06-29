class NewslettersController < ApplicationController
  #skip_before_filter :signed_in_user, :only => [:create]
	def create
		if(params.include?(:email) && params[:email] != "" && !params[:email].nil? && params[:email] =~/\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i)
			t = Newsletter.new(email: params[:email])
			t.save
			render :json => { :status => 1 }
			return
		end
        format.json { render :json => { :error => "1" }}
	end
end