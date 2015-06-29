module EvalTestsHelper

def correct_test_user?(id)
   @eval_test = EvalTest.find(id)
   if @eval_test.user
   		@user = User.find(@eval_test.user.id)
   		return current_user?(@user)
   else
   		return is_current_user_sysadmin?
   end
end

end
