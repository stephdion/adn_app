class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper
  include AuthorizationHelper

  before_filter :signed_in_user
  around_filter :scope_current_organization

  # Force signout to prevent CSRF attacks
  def handle_unverified_request
    sign_out
    super
  end

  private

  def scope_current_organization
  Organization.current_organization = session[:organization_id]
  set_current_membership
    yield
    ensure
  Organization.current_organization = nil
  end

  def set_current_membership
    user = User.find_by_remember_token(cookies[:remember_token])
    if user != nil #found user
      if (session[:organization_id] == 0 || session[:organization_id] == nil)
        #set membership for first time in session
          if user.memberships.first
            @current_organization = user.memberships.first.organization
            @current_role = user.memberships.first.role
          else 
            @current_organization = Organization.first
            @current_role = Role.athlete_role
          end
          session[:organization_id] = @current_organization.id

      else #session variable alredy been set - now set @current_organization
        @current_organization = Organization.find(session[:organization_id])
        @current_role = user.current_role
        @adn_sysadmin = user.adn_sysadmin?
      end
    end
    #raise @current_organization.name + " " + @current_role.name
  end

end
