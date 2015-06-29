module ProgrammesHelper

	def correct_programme_user?(id)
      @programme = Programme.find(id)
      if @programme.user
   		  @user = User.find(@programme.user.id)
   		return current_user?(@user)
   	  else
   		  return is_current_user_sysadmin?
   	  end
	end

end
