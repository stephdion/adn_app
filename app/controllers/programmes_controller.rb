class ProgrammesController < ApplicationController
  def new
    @programme = Programme.new
  end

  def create
    @programme = current_user.programmes.build(params[:programme].permit(:name, :description,
      :exercise_ids)) if signed_in?
    if @programme.save
      flash[:success] = "Nouvelle programme cree!"
      redirect_to @programme
    else
      render 'new'
    end
  end

  def show
    @programme = Programme.find(params[:id])
  end

  def index
    @programmes = Programme.order(:name)
  end

  def edit
   @programme = Programme.find(params[:id])
  end

  def destroy
    Programme.find(params[:id]).destroy
    flash[:success] = "Programme supprime."
    redirect_to programmes_url
  end

  def update
    @programme = Programme.find(params[:id])
    if @programme.update_attributes(params[:programme].permit(:name, :description,
      :exercise_ids))
      flash[:success] = "Programme modifier"
      redirect_to @programme
    else
      render 'edit'
    end
  end


  private

  def correct_user_for_programme
      @programme = Programme.find(params[:id])
      if @programme.user
          @user = User.find(@programme.user.id)
          redirect_to(root_path) unless current_user?(@user)
        else
          redirect_to(root_path) unless is_current_user_sysadmin?
        end
  end
end

