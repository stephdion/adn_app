module ResultatsHelper

def correct_resultat_user?(id)
   	 return (id.to_i == current_user.id.to_i) || is_current_user_admin?
end

end

