class SessionsController < ApplicationController
  skip_before_filter :signed_in_user

  def new
  end

  def create
    user = User.unscoped.find_by_email(params[:session][:email].downcase) 
    if !user 
      flash[:error] = I18n.t(:session_invalid_email)
      redirect_to ouverture_path
    elsif user.is_enabled != true
      flash[:error] = I18n.t(:session_account_not_activated)
      redirect_to root_url
    elsif user.authenticate(params[:session][:password])
      session[:organization_id] = user.organizations.first.id
      if user.is_temporary?
        redirect_to update_temporary_user_path :id => user.id
      elsif !user.registration_token
        sign_in user
        redirect_back_or user
      end
    elsif
        flash.now[:error] = I18n.t(:session_incorrect_password)
        render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_url
  end
end