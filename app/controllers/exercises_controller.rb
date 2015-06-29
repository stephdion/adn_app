class ExercisesController < ApplicationController
  include SessionsHelper

  before_filter :correct_user_for_exercise,   only: [:edit, :update, :destroy]

  def show
    @exercise = Exercise.find(params[:id])
  end

  def new
    @exercise = Exercise.new
  end

  def edit
    @exercise = Exercise.find(params[:id])
  end

  def edit_multiple
    @exercises = Exercise.where("organization_id IN (?)", [Organization.current_organization]).reorder(:short_name)
  end

  def index
    @exercises = Exercise.where("organization_id IN (?)", [Organization.current_organization, Organization.admin_organization]).reorder(:short_name)
  end

  def create
    @exercise = current_user.exercises.build(params[:exercise].permit(:exercise, :name, :short_name, :exercise_subcategory_id, 
      :organization_id, :description, :image, :user_id, :short_desc, :video)) if signed_in?
    if @exercise.save
      flash[:success] = "Nouvelle exercise cree!"
      redirect_to @exercise
    else
      render 'new'
    end
  end

  def update
    @exercise = Exercise.find(params[:id])
    if params[:exercise][:user_id].nil? || params[:exercise][:user_id] == ""
      params[:exercise][:user_id] = @exercise.user_id
    end
    if @exercise.update_attributes(params[:exercise].permit(:exercise, :name, :short_name, :exercise_subcategory_id, 
      :organization_id, :description, :image, :user_id, :short_desc, :video))
      flash[:success] = "Exercice modifier"
      redirect_to @exercise
    else
      render 'edit'
    end
  end

  def update_multiple
    Exercise.update(params[:exercises].keys, params[:exercises].values)
    redirect_to exercises_path
  end

  def destroy
    Exercise.find(params[:id]).destroy
    flash[:success] = "Exercise supprime."
    redirect_to exercises_url
  end

  private

  def correct_user_for_exercise
      @exercise = Exercise.find(params[:id])
        if @exercise.user
          @user = User.find(@exercise.user.id)
          redirect_to(root_path) unless (current_user?(@user) || is_current_user_sysadmin?)
        else
          redirect_to(root_path) unless is_current_user_sysadmin?
        end
  end
end
