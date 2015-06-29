module SessionsHelper

  @@SYS_ADM="SYSADM"
  @@ADN_ORG = 1

  def sign_in(user)
    cookies.permanent[:remember_token] = user.remember_token
    self.current_user = user
  end

  def signed_in?
    !current_user.nil?
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    @current_user ||= User.find_by_remember_token(cookies[:remember_token])
  end

  def current_user?(user)
    user == current_user
  end

  def is_owner_or_admin?
    return  current_user!=nil &&
        (current_user.id == params['id'].to_i ||
            is_current_user_in_role?(@@SYS_ADM))
  end

  def is_owner_or_admin
    unless is_owner_or_admin?
      redirect_to ouverture_url, notice: I18n.t(:general_access_denied)
    end
  end

  def is_adn_sysadmin?
    unless is_current_user_adn_sysadmin?
      redirect_to ouverture_url, notice: I18n.t(:general_access_denied)
    end
  end

  def deny_athlete
    if is_current_user_in_role?('ATHLETE')
      redirect_to ouverture_url, notice: I18n.t(:general_access_denied)
    end
  end

  def is_current_user_owner_or_admin?
    if !is_owner_or_admin? || is_current_user_in_role?('ATHLETE')
      redirect_to ouverture_url, notice: I18n.t(:general_access_denied)
    end
  end

  # use this if user not signed in
  def is_current_user_in_role?(roleName)
      return @current_role.try(:code) == roleName
  end

  # use this if user not signed in
  def is_current_user_in_any_role?(role_array)
    return role_array.include?(@current_role.try(:code))
  end

  def is_user_in_role?(user, roleName)
    if user && user.current_role
      return user.current_role.code == roleName
    else
      return false
    end
  end

  def is_user_in_any_role?(user, role_array)
    return role_array.include?(user.current_role.code)
  end

  def is_current_user_parent?
    return is_current_user_in_role?('PARENT')
  end

  def is_current_user_admin?
    return is_current_user_in_role?(@@SYS_ADM) || is_current_user_in_role?('DIR')
  end

  def is_current_user_trainer?
    return is_current_user_in_role?('TRAINER') || is_current_user_in_role?('PHYSIO')
  end

  def is_current_user_director?
    return is_current_user_in_role?('DIR')
  end

  def is_current_user_in_role(roleName)
    unless is_current_user_in_role?(roleName)
      store_location
      redirect_to ouverture_url, notice: "Please sign in."
    end
  end

  #check if user is included in current organization
  def is_user_in_current_org?(id)
    return @current_organization.users.include?(User.find(id))
  end

  #check if team administrator is included in current organization
  def is_equipe_in_current_org?(admin_id)
    return is_user_in_current_org?(admin_id)
  end
  
  def signed_in_user
    unless signed_in?
      store_location
      redirect_to ouverture_url, notice: I18n.t(:security_sign_in)
    end
  end

  def sign_out
    self.current_user = nil
    cookies.delete(:remember_token)
  end

  def store_location
    session[:return_to] = request.url
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end

end
