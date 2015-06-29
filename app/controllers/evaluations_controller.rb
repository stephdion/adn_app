class EvaluationsController < ApplicationController

  before_filter :create_index_evaluation_permissions,   :only => [:new, :create, :index]
  before_filter :show_evaluation_permissions,           :only => [:show]
  before_filter :update_evaluation_permissions,         :only => [:edit, :edit_test_order, :edit_exercise_order]
  before_filter :delete_evaluation_permissions,         :only => [:destroy]
  
  def new
    @evaluation = Evaluation.new
    @tests = @current_organization.eval_tests.reorder(:short_name)
  end

  def create
    @evaluation = current_user.evaluations.build(params[:evaluation].permit(:name, :user_id,
      :eval_type_id, :organization_id, :description, :point_desc0, :point_desc1, :point_desc2,
      :point_desc3, :point_presc0, :point_presc1, :point_presc2, :point_presc3, :eval_test_ids)) if signed_in?
    if @evaluation.save
      create_test_set(params[:evaluation][:eval_test_ids], @evaluation.id)
      flash[:success] = "Nouvelle evaluation cree!"
      redirect_to @evaluation
    else
      render 'new'
    end
  end

  def show
    @evaluation = Evaluation.find(params[:id])
  end

  def index
    @evaluations = @current_organization.evaluations
  end

  def edit
   @evaluation = Evaluation.find(params[:id])
   @tests = @current_organization.eval_tests.reorder(:short_name)
  end

  def edit_test_order
    @evaluation = Evaluation.find(params[:id])
    render 'edit_test_order'
  end 

  def edit_exercise_order
    @evaluation = Evaluation.find(params[:id])
    render 'edit_exercise_order'
  end 

  def destroy
    Evaluation.find(params[:id]).destroy
    flash[:success] = "Evaluation supprime."
    redirect_to evaluations_url
  end

  def update
    @evaluation = Evaluation.find(params[:id])
    if (params[:user] and is_current_user_sysadmin?)
      @evaluation.user = User.find(params[:user][:id])
    end
    if @evaluation.update_attributes(params[:evaluation].permit(:name, :user_id,
      :eval_type_id, :organization_id, :description, :point_desc0, :point_desc1, :point_desc2,
      :point_desc3, :point_presc0, :point_presc1, :point_presc2, :point_presc3, :eval_test_ids))
      update_test_set(params[:evaluation][:eval_test_ids], @evaluation.id)

      flash[:success] = "Evaluation modifier"
      redirect_to @evaluation
    else
      @tests = @current_organization.eval_tests.reorder(:short_name)
      render 'edit'
    end
  end

  def update_test_order
    params[:test_sets].each do |test_set|
      TestSet.find(test_set[0]).update(test_order: test_set[1][:test_order])
    end

    @evaluation = Evaluation.find(params[:id])
    redirect_to @evaluation
  end

  def update_exercise_order
    params[:test_sets].each do |test_set|
      TestSet.find(test_set[0]).update(exercise_order: test_set[1][:exercise_order])
    end

     @evaluation = Evaluation.find(params[:id])
     redirect_to @evaluation
  end

  private

  def create_test_set(eval_test_ids, eval_id)
    eval_test_ids.each do |eval_test_id|

      current_eval_test = TestSet.new(eval_test_id: eval_test_id, evaluation_id: eval_id)
      current_eval_test.save
    end
  end

  def update_test_set(eval_test_ids, eval_id)
    current_tests = TestSet.where('evaluation_id = ?', eval_id)

    current_tests.each do |test_sets|
      if !eval_test_ids.include? test_sets.eval_test_id
        test_sets.destroy
      end
    end

    eval_test_ids.each do |eval_test_id|
      if eval_test_id != ''
        trigger = TestSet.where('eval_test_id = ? AND evaluation_id = ?', eval_test_id, eval_id).first
        if trigger.nil?
          current_eval_test = TestSet.new(eval_test_id: eval_test_id, evaluation_id: eval_id)
          current_eval_test.save
        end
      end
    end
  end

  def correct_user_for_evaluation(evaluation)
    if evaluation.user
        if @current_user == evaluation.user
          return true
        else
          return false
        end
    else
      return false
    end
  end

  def create_index_evaluation_permissions
    # Everyone in the organization can create an evaluation or see the index except Parents and Athletes
    if !check_for_permission(@current_organization.id, @current_user.id, [Role.dir_role, Role.sysadm_role, Role.trainer_role, Role.physio_role])
      redirect_to current_user, notice: I18n.t(:general_access_denied) + I18n.t(:security_PARENT_ATHLETE_deny)
    end
  end

  def show_evaluation_permissions
    # everyone in org can look at the evaluations
    @evaluation = Evaluation.find(params[:id])
    if !check_for_permission(@evaluation.organization_id, @current_user.id, [Role.dir_role, Role.sysadm_role, Role.trainer_role, Role.physio_role, Role.parent_role, Role.athlete_role])
      redirect_to current_user, notice: I18n.t(:general_access_denied) + I18n.t(:security_evaluation_not_in_org)
    end
  end

  def update_evaluation_permissions
    # only owner, sysadmin and dir can update the evaluations
    @evaluation = Evaluation.find(params[:id])
    if !check_for_permission(@evaluation.organization_id, @current_user.id, [Role.dir_role, Role.sysadm_role]) && !correct_user_for_evaluation(@evaluation)
      redirect_to evaluations_path, notice: I18n.t(:general_access_denied) + I18n.t(:security_not_DIR_SYSADM_owner)
    end
  end

  def delete_evaluation_permissions
    # only owner, sysadmin and dir can delete an evaluation
    update_evaluation_permissions
    # don't delete teams with participations
    if @evaluation.eval_tests.any?
      redirect_to @evaluation, notice: I18n.t(:general_access_denied) + I18n.t(:security_evaluation_delete_deny)
    end
  end

end
