class ExerciseSubcategoriesController < ApplicationController

before_filter :exercise_subcategories_permissions, :only => [:index, :create, :new]
before_filter :exercise_subcategory_permissions, :only => [:show, :edit, :update, :destroy]
  
  # GET /exercise_subcategories
  # GET /exercise_subcategories.json
  def index
    @exercise_subcategories = ExerciseSubcategory.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @exercise_subcategories }
    end
  end

  # GET /exercise_subcategories/1
  # GET /exercise_subcategories/1.json
  def show
    @exercise_subcategory = ExerciseSubcategory.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @exercise_subcategory }
    end
  end

  # GET /exercise_subcategories/new
  # GET /exercise_subcategories/new.json
  def new
    @exercise_subcategory = ExerciseSubcategory.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @exercise_subcategory }
    end
  end

  # GET /exercise_subcategories/1/edit
  def edit
    @exercise_subcategory = ExerciseSubcategory.find(params[:id])
  end

  # POST /exercise_subcategories
  # POST /exercise_subcategories.json
  def create
    @exercise_subcategory = ExerciseSubcategory.new(exercise_subcategory_params)

    respond_to do |format|
      if @exercise_subcategory.save
        format.html { redirect_to exercise_categories_path }
        format.json { render json: exercise_categories_path, status: :created, location: @exercise_subcategory }
      else
        format.html { render action: "new" }
        format.json { render json: @exercise_subcategory.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /exercise_subcategories/1
  # PATCH/PUT /exercise_subcategories/1.json
  def update
    @exercise_subcategory = ExerciseSubcategory.find(params[:id])

    respond_to do |format|
      if @exercise_subcategory.update_attributes(exercise_subcategory_params)
        format.html { redirect_to exercise_categories_path }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @exercise_subcategory.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /exercise_subcategories/1
  # DELETE /exercise_subcategories/1.json
  def destroy

    
    @exercise_subcategory = ExerciseSubcategory.find(params[:id])

    if @exercise_subcategory.exercises.any?
      flash[:error] = I18n.t(:subcategory_ex_delete_failed)

      respond_to do |format|
      format.html { redirect_to @exercise_subcategory }
      format.json { head :no_content }
      end
    else
      @exercise_subcategory.destroy
      flash[:success] = I18n.t(:subcategory_delete_success)

      respond_to do |format|
      format.html { redirect_to exercise_categories_url }
      format.json { head :no_content }
      end
    end
    
  end

  private

    # Use this method to whitelist the permissible parameters. Example:
    # params.require(:person).permit(:name, :age)
    # Also, you can specialize this method with per-user checking of permissible attributes.
    def exercise_subcategory_params
      params.require(:exercise_subcategory).permit(:exercise_category_id, :name)
    end

    def exercise_subcategories_permissions
      # only ADN Sysadmin, director, and sysadm allowed to view or create this data
      if !check_for_permission(@current_organization.id, @current_user.id, [Role.dir_role, Role.sysadm_role])
        redirect_to current_user, notice: I18n.t(:general_access_denied) + I18n.t(:security_not_DIR_SYSADM)
      end
    end

    def exercise_subcategory_permissions
      # only ADN Sysadmin, director, and sysadm allowed to RUD this data
      ex_subcat = ExerciseSubcategory.find(params[:id])
      if !check_for_permission(ex_subcat.exercise_category.organization_id, @current_user.id, [Role.dir_role, Role.sysadm_role])
        redirect_to exercise_categories_path, notice: I18n.t(:general_access_denied) + I18n.t(:security_subcategory_not_in_org)
      end
    end
    
end
