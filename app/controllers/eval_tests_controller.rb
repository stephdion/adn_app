class EvalTestsController < ApplicationController
  include SessionsHelper

  before_filter :correct_user_for_test,   only: [:edit, :update, :destroy]

  def show
    @eval_test = EvalTest.find(params[:id])
  end

  def new
    @eval_test = EvalTest.new
    @exercises = @current_organization.exercises.reorder(:short_name)
  end

  def edit
    @eval_test = EvalTest.find(params[:id])
    @exercises = @current_organization.exercises.reorder(:short_name)
  end

  def edit_multiple
    @eval_tests = EvalTest.where("organization_id IN (?)", [Organization.current_organization]).reorder(:short_name)
  end

  def edit_exercise_order
    @eval_test = EvalTest.find(params[:id])
    render 'edit_exercise_order'
  end 

  def index
    @eval_tests = EvalTest.where("organization_id IN (?)", [Organization.current_organization, Organization.admin_organization]).reorder(:short_name)
  end

  def create
    @eval_test = current_user.eval_tests.build(params[:eval_test].permit(:name, :short_name, :organization_id,
      :description, :user_id, :component, :image, :left_right, :video, :exercise_ids)) if signed_in?
    if @eval_test.save
      create_prescriptions(params[:eval_test][:exercise_ids], @eval_test.id)
      flash[:success] = "Nouveau test cree!"
      redirect_to @eval_test
    else
      @exercises = @current_organization.exercises.reorder(:short_name)
      render 'new'
    end
  end

  def update
    @eval_test = EvalTest.find(params[:id])
    if params[:eval_test][:user_id] == "" || params[:eval_test][:user_id].nil?
      params[:eval_test][:user_id] = @eval_test.user_id
    end
    if @eval_test.update_attributes(params[:eval_test].permit(:name, :short_name, :organization_id,
      :description, :user_id, :component, :image, :left_right, :video, :exercise_ids))
      update_prescriptions(params[:eval_test][:exercise_ids], @eval_test.id)
      flash[:success] = "Test modifier"
      redirect_to @eval_test
    else
      render 'edit'
    end
  end

  def update_multiple
    EvalTest.update(params[:eval_test].keys, params[:eval_test].values)
    redirect_to eval_tests_path
  end

  def update_exercise_order
    params[:prescriptions].each do |prescription|
      Prescription.find(prescription[0]).update(exercise_order: prescription[1][:exercise_order])
    end

     @eval_test = EvalTest.find(params[:id])
     redirect_to @eval_test
  end

  def create_prescriptions(exercice_ids, eval_test_id)
    exercice_ids.each do |exercice_id|
      if exercice_id != ""
        current_prescription = Prescription.new(eval_test_id: eval_test_id, exercise_id: exercice_id)
        current_prescription.save
      end
    end
  end

  def update_prescriptions(exercice_ids, eval_test_id)
    current_eval_test = Prescription.where('eval_test_id = ?', eval_test_id)

    current_eval_test.each do |eval_test|
      if !exercice_ids.include? eval_test.exercise_id 
        eval_test.destroy
      end
    end

    exercice_ids.each do |exercice_id|
      if exercice_id != ''
        trigger = Prescription.where('exercise_id  = ? AND eval_test_id = ?', exercice_id, eval_test_id).first
        if trigger.nil?
          current_prescription = Prescription.new(exercise_id: exercice_id, eval_test_id: eval_test_id)
          current_prescription.save
        end
      end
    end
  end

  def destroy
    EvalTest.find(params[:id]).destroy
    flash[:success] = "Test supprime."
    redirect_to eval_tests_url
  end

private

  def correct_user_for_test
      @eval_test = EvalTest.find(params[:id])
        if @eval_test.user
          @user = User.find(@eval_test.user.id)
          redirect_to(root_path) unless (current_user?(@user) || is_current_user_sysadmin?)
        else
          redirect_to(root_path) unless is_current_user_sysadmin?
        end
  end

end
