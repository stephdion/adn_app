module AuthorizationHelper

def authorization_profile_page

	user = User.find(params[:id])
	viewer_role = @current_role.code
	user_role = user.current_role.code
	if current_user.id == user.id || current_user.children.includes(user)
		owner = "TRUE"
	else
		owner = "FALSE"
	end

	if viewer_role == "ATHLETE"
		if user_role == "ATHLETE" && owner == "TRUE"
			@view = "DETAILED"
			@edit_privilege = "TRUE"
		elsif user_role == "ATHLETE" && owner == "FALSE"
			@view = "MINIMAL"
			@edit_privilege = "FALSE"
		elsif user_role == "PARENT"
			@view = "MINIMAL"
			@edit_privilege = "FALSE"
		elsif user_role == "TRAINER"
			@view = "MINIMAL"
			@edit_privilege = "FALSE"
		elsif user_role == "PHYSIO"
			@view = "MINIMAL"
			@edit_privilege = "FALSE"
		elsif user_role == "DIR"
			@view = "MINIMAL"
			@edit_privilege = "FALSE"
		elsif user_role == "SYSADMIN"
			@view = "MINIMAL"
			@edit_privilege = "FALSE"
		else
			@view = "MINIMAL"
			@edit_privilege = "FALSE"
		end

	elsif viewer_role == "PARENT"
		if user_role == "ATHLETE" && owner == "TRUE"
			@view = "DETAILED"
			@edit_privilege = "FALSE"
		elsif user_role == "ATHLETE" && owner == "FALSE"
			@view = "MINIMAL"
			@edit_privilege = "FALSE"
		elsif user_role == "OWN PARENT"
			@view = "DETAILED"
			@edit_privilege = "TRUE"
		elsif user_role == "PARENT"
			@view = "MINIMAL"
			@edit_privilege = "FALSE"
		elsif user_role == "TRAINER"
			@view = "MINIMAL"
			@edit_privilege = "FALSE"
		elsif user_role == "PHYSIO"
			@view = "MINIMAL"
			@edit_privilege = "FALSE"
		elsif user_role == "DIR"
			@view = "MINIMAL"
			@edit_privilege = "FALSE"
		elsif user_role == "SYSADMIN"
			@view = "MINIMAL"
			@edit_privilege = "FALSE"
		else
			@view = "MINIMAL"
			@edit_privilege = "FALSE"
		end

	elsif viewer_role == "TRAINER"
		if user_role == "ATHLETE"
			@view = "DETAILED"
			@edit_privilege = "FALSE"
		elsif user_role == "PARENT"
			@view = "DETAILED"
			@edit_privilege = "FALSE"
		elsif user_role == "TRAINER" && owner == "FALSE"
			@view = "MINIMAL"
			@edit_privilege = "FALSE"
		elsif user_role == "TRAINER" && owner == "TRUE"
			@view = "DETAILED"
			@edit_privilege = "TRUE"
		elsif user_role == "PHYSIO"
			@view = "MINIMAL"
			@edit_privilege = "FALSE"
		elsif user_role == "DIR"
			@view = "MINIMAL"
			@edit_privilege = "FALSE"
		elsif user_role == "SYSADMIN"
			@view = "MINIMAL"
			@edit_privilege = "FALSE"
		else
			@view = "MINIMAL"
			@edit_privilege = "FALSE"
		end

	elsif viewer_role == "PHYSIO"
		if user_role == "ATHLETE"
			@view = "DETAILED"
			@edit_privilege = "FALSE"
		elsif user_role == "PARENT"
			@view = "DETAILED"
			@edit_privilege = "FALSE"
		elsif user_role == "TRAINER"
			@view = "MINIMAL"
			@edit_privilege = "FALSE"
		elsif user_role == "PHYSIO" && owner == "TRUE"
			@view = "DETAILED"
			@edit_privilege = "TRUE"
		elsif user_role == "PHYSIO" && owner == "FALSE"
			@view = "MINIMAL"
			@edit_privilege = "FALSE"
		elsif user_role == "DIR"
			@view = "MINIMAL"
			@edit_privilege = "FALSE"
		elsif user_role == "SYSADMIN"
			@view = "MINIMAL"
			@edit_privilege = "FALSE"
		else
			@view = "MINIMAL"
			@edit_privilege = "FALSE"
		end

	elsif viewer_role == "DIR"
		if user_role == "DIR" && owner == "TRUE"
			@view = "DETAILED"
			@edit_privilege = "TRUE"
		elsif user_role == "DIR" && owner == "FALSE"
			@view = "MINIMAL"
			@edit_privilege = "TRUE"
		elsif user_role == "SYSADMIN"
			@view = "MINIMAL"
			@edit_privilege = "FALSE"
		else
			@view = "DETAILED"
			@edit_privilege = "FALSE"
		end

	else viewer_role == "SYSADMIN"
		@view = "DETAILED"
		@edit_privilege = "TRUE"
	end
end

def have_access_to_profil(profil_id)
	user_is_in_user_organization(profil_id)

	if profil_id.to_i == current_user.id.to_i
		return true
	end

	if have_access_to_team_member_profile?
		return user_is_in_user_team(profil_id)
	end

	if have_access_to_organization_member?
		return user_is_in_user_organization(profil_id)
	end

	if is_current_user_sysadmin?
		return true
	end

	if @current_role.code == "PARENT"
		return user_is_user_child(profil_id)
	end

	return false
end

def check_for_permission(organization_id, user_id, role_array)
	if @adn_sysadmin
		return true
	end

	memberships = Membership.where("organization_id = ? AND user_id = ? AND role_id IN (?)", organization_id, user_id, role_array)

	if memberships.any?
		return true
	else
		return false
	end
end

def have_access_to_team_member_profile?
	return @current_role.code.upcase == "PHYSIO" ||
		   @current_role.code.upcase == "TRAINER"
end

def have_access_to_organization_member?
	return @current_role.code.upcase == "DIR"
end

def user_is_user_child(profil_id)
	return FamilyMember.where("parent_id = ? AND user_id = ?", current_user.id, profil_id).count > 0
end

def user_is_in_user_team(profil_id)
	users = User.find(current_user.id).current_team_members

	users.each do |user|
		if user.id.to_i == profil_id.to_i
			return true
		end
	end

	return false
end

def user_is_in_user_organization(profil_id)
	user_memberships = User.find(current_user.id).memberships

	user_memberships.each do |membership, index|
		membership.organization.equipes.each do |equipe, index|
			equipe.get_all_members.each do |user, index|

				if user.id.to_i == profil_id.to_i
					return true
				end
			end
		end
	end

	return false
end

def deny_everyone
    redirect_to current_user, notice: I18n.t(:general_access_denied)
end

def deny_athletes_and_parents
	if @current_role.code == ("ATHLETE" || "PARENT")
       redirect_to current_user, notice: I18n.t(:general_access_denied) + ":parents and athletes denied"
    end
end

def sysadmin_and_director_only
	if @current_role.code != ('SYSADM' || 'DIR')
       redirect_to current_user, notice: I18n.t(:general_access_denied) + ":not sysadmin or director"
    end
end

def sysadmin_only
	if @current_role.code != 'SYSADM'
       redirect_to current_user, notice: I18n.t(:general_access_denied) + ":not sysadmin"
    end
end

def adn_sysadmin_only
	if !@adn_sysadmin
       redirect_to current_user, notice: I18n.t(:general_access_denied) + ":not ADN sysadmin"
    end
end

def edit_privileges
	if !(current_user.id == User.find(params[:id]).id || @current_role.code != 'SYSADM' || @adn_sysadmin)
		redirect_to current_user, notice: I18n.t(:general_access_denied) + ":not owner or sysadmin"
	end
end

def is_athlete_or_parent
	if @current_role.code == ("ATHLETE" || "PARENT")
		return true
	end
end

def is_current_user_sysadmin?
	return (@current_role.code == 'DIR') || (@current_role.code == 'SYSADM') || @adn_sysadmin
end

def is_current_user_adn_sysadmin?
    return @adn_sysadmin
end

end
