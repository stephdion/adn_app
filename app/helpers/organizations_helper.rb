module OrganizationsHelper

	def organizations_list
		organizations = Array.new
		if is_current_user_adn_sysadmin?
			organizations_list = Organization.all.order(:name).to_a
		else
			organizations_list = current_user.organizations.to_a					
		end
		if organizations_list.include?(@current_organization)
      		organizations_list.delete(@current_organization)
  		end
  		return organizations_list
	end

end
