module ExercisesHelper

  def correct_exercise_user?(id)
     @exercise = Exercise.find(id)
   		if @exercise.user
   			@user = User.find(@exercise.user.id)
   			return current_user?(@user)
   		else
   			return is_current_user_sysadmin?
   		end
  end
end
