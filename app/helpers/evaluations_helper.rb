module EvaluationsHelper

def correct_evaluation_user?(id)
   @evaluation = Evaluation.find(id)
   		if @evaluation.user
   			@user = User.find(@evaluation.user.id)
   			return current_user?(@user)
   		else
   			return is_current_user_sysadmin?
   		end
end

end
