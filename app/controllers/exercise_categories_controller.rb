class ExerciseCategoriesController < ApplicationController

before_filter :exercise_categories_permissions, :only => [:index, :create, :new]
before_filter :exercise_category_permissions, :only => [:show, :edit, :update, :destroy]

  # GET /exercise_categories
  # GET /exercise_categories.json
  def index
    @exercise_categories = ExerciseCategory.where("organization_id IN (?)", [Organization.current_organization, Organization.admin_organization])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @exercise_categories }
    end
  end

  # GET /exercise_categories/1
  # GET /exercise_categories/1.json
  def show
    @exercise_category = ExerciseCategory.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @exercise_category }
    end
  end

  # GET /exercise_categories/new
  # GET /exercise_categories/new.json
  def new
    @exercise_categories = ExerciseCategory.all
    @exercise_category = ExerciseCategory.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @exercise_category }
    end
  end

  # GET /exercise_categories/1/edit
  def edit
    @exercise_categories = ExerciseCategory.all
    @exercise_category = ExerciseCategory.find(params[:id])
  end

  # POST /exercise_categories
  # POST /exercise_categories.json
  def create
    @exercise_category = ExerciseCategory.new(params[:exercise_category].permit(:name, :organization_id))

    respond_to do |format|
      if @exercise_category.save
        format.html { redirect_to exercise_categories_path }
        format.json { render json: exercise_categories_path, status: :created, location: @exercise_category }
      else
        format.html { render action: "new" }
        format.json { render json: @exercise_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /exercise_categories/1
  # PATCH/PUT /exercise_categories/1.json
  def update
    @exercise_category = ExerciseCategory.find(params[:id])
  
    respond_to do |format|
      if @exercise_category.update_attributes(params[:exercise_category])
        format.html { redirect_to exercise_categories_path }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @exercise_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /exercise_categories/1
  # DELETE /exercise_categories/1.json
  def destroy
    @exercise_category = ExerciseCategory.find(params[:id])

    if @exercise_category.exercise_subcategories.any?
      flash[:error] = I18n.t(:category_delete_failed)

      respond_to do |format|
      format.html { redirect_to @exercise_category }
      format.json { head :no_content }
      end
    else
      @exercise_category.destroy
      flash[:success] = I18n.t(:category_delete_success)

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
    def exercise_category_params
      params.require(:exercise_category).permit(:name)
    end

    def exercise_categories_permissions
      # only ADN Sysadmin, director, and sysadm allowed to view or create this data
      if !check_for_permission(@current_organization.id, @current_user.id, [Role.dir_role, Role.sysadm_role])
        redirect_to current_user, notice: I18n.t(:general_access_denied) + I18n.t(:security_not_DIR_SYSADM)
      end
    end

    def exercise_category_permissions
      # only ADN Sysadmin, director, and sysadm allowed to RUD this data
      ex_cat = ExerciseCategory.find(params[:id])
      if !check_for_permission(ex_cat.organization_id, @current_user.id, [Role.dir_role, Role.sysadm_role])
        redirect_to exercise_categories_path, notice: I18n.t(:general_access_denied) + I18n.t(:security_category_not_in_org)
      end
    end

end
