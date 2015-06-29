module EquipesHelper

	def correct_equipe_user?(id)
     	@equipe = Equipe.find(id)
   		if @equipe.user
   			return (current_user?(@equipe.user) || is_current_user_sysadmin?)
   		else
   			return is_current_user_sysadmin?
   		end
	end
end
