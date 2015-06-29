class TestCategoriesController < ApplicationController

  before_filter :test_categories_permissions, :only => [:index, :create, :new]
  before_filter :test_category_permissions, :only => [:show, :edit, :update, :destroy]
  
  # GET /test_categories
  # GET /test_categories.json
  def index
    @test_categories = TestCategory.where("organization_id IN (?)", [Organization.current_organization, Organization.admin_organization])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @test_categories }
    end
  end

  # GET /test_categories/1
  # GET /test_categories/1.json
  def show
    @test_category = TestCategory.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @test_category }
    end
  end

  # GET /test_categories/new
  # GET /test_categories/new.json
  def new
    @test_category = TestCategory.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @test_category }
    end
  end

  # GET /test_categories/1/edit
  def edit
    @test_category = TestCategory.find(params[:id])
  end

  # POST /test_categories
  # POST /test_categories.json
  def create
    @test_category = TestCategory.new(params[:test_category].permit(:name,
      :organization_id))

    respond_to do |format|
      if @test_category.save
        format.html { redirect_to test_categories_path }
        format.json { render json: test_categories_path, status: :created, location: test_categories_path }
      else
        format.html { render action: "new" }
        format.json { render json: @test_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /test_categories/1
  # PATCH/PUT /test_categories/1.json
  def update
    @test_category = TestCategory.find(params[:id])

    respond_to do |format|
      if @test_category.update_attributes(params[:test_category].permit(:name,
      :organization_id))
        format.html { redirect_to test_categories_path }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @test_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /test_categories/1
  # DELETE /test_categories/1.json
  def destroy
    @test_category = TestCategory.find(params[:id])

    if @test_category.test_subcategories.any?
      flash[:error] = I18n.t(:category_delete_failed)

      respond_to do |format|
      format.html { redirect_to @test_category }
      format.json { head :no_content }
      end
    else
    @test_category.destroy

    respond_to do |format|
      format.html { redirect_to test_categories_url }
      format.json { head :no_content }
    end
   end
  end

  private

    # Use this method to whitelist the permissible parameters. Example:
    # params.require(:person).permit(:name, :age)
    # Also, you can specialize this method with per-user checking of permissible attributes.
    def test_category_params
      params.require(:test_category).permit(:name)
    end

    def test_categories_permissions
      # only ADN Sysadmin, director, and sysadm allowed to view or create this data
      if !check_for_permission(@current_organization.id, @current_user.id, [Role.dir_role, Role.sysadm_role])
        redirect_to current_user, notice: I18n.t(:general_access_denied) + I18n.t(:security_not_DIR_SYSADM)
      end
    end

    def test_category_permissions
      # only ADN Sysadmin, director, and sysadm allowed to RUD this data
      test_cat = TestCategory.find(params[:id])
      if !check_for_permission(test_cat.organization_id, @current_user.id, [Role.dir_role, Role.sysadm_role])
        redirect_to test_categories_path, notice: I18n.t(:general_access_denied) + I18n.t(:security_category_not_in_org)
      end
    end

end
