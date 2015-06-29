module RolesHelper

def get_role_id(role_code)
	role = Role.where(:code => role_code).first
	if role != nil
		return role.id
	else 
		return "error"
	end
end

end
