class TestSubcategoriesController < ApplicationController

  before_filter :test_subcategories_permissions, :only => [:index, :create, :new]
  before_filter :test_subcategory_permissions, :only => [:show, :edit, :update, :destroy]

  # GET /test_subcategories
  # GET /test_subcategories.json
  def index
    @test_subcategories = TestSubcategory.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @test_subcategories }
    end
  end

  # GET /test_subcategories/1
  # GET /test_subcategories/1.json
  def show
    @test_subcategory = TestSubcategory.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @test_subcategory }
    end
  end

  # GET /test_subcategories/new
  # GET /test_subcategories/new.json
  def new
    @test_subcategory = TestSubcategory.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @test_subcategory }
    end
  end

  # GET /test_subcategories/1/edit
  def edit
    @test_subcategory = TestSubcategory.find(params[:id])
  end

  # POST /test_subcategories
  # POST /test_subcategories.json
  def create
    @test_subcategory = TestSubcategory.new(test_subcategory_params)

    respond_to do |format|
      if @test_subcategory.save
        format.html { redirect_to test_categories_path }
        format.json { render json: test_categories_path, status: :created, location: test_categories_path }
      else
        format.html { render action: "new" }
        format.json { render json: @test_subcategory.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /test_subcategories/1
  # PATCH/PUT /test_subcategories/1.json
  def update
    @test_subcategory = TestSubcategory.find(params[:id])

    respond_to do |format|
      if @test_subcategory.update_attributes(test_subcategory_params)
        format.html { redirect_to test_categories_path }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @test_subcategory.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /test_subcategories/1
  # DELETE /test_subcategories/1.json
  def destroy
    @test_subcategory = TestSubcategory.find(params[:id])

    if @test_subcategory.eval_tests.any?
      flash[:error] = I18n.t(:subcategory_te_delete_failed)

      respond_to do |format|
      format.html { redirect_to @test_subcategory }
      format.json { head :no_content }
      end
    else
    @test_subcategory.destroy

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
    def test_subcategory_params
      params.require(:test_subcategory).permit(:name, :test_category_id)
    end

    def test_subcategories_permissions
      # only ADN Sysadmin, director, and sysadm allowed to view or create this data
      if !check_for_permission(@current_organization.id, @current_user.id, [Role.dir_role, Role.sysadm_role])
        redirect_to current_user, notice: I18n.t(:general_access_denied) + I18n.t(:security_not_DIR_SYSADM)
      end
    end

    def test_subcategory_permissions
      # only ADN Sysadmin, director, and sysadm allowed to RUD this data
      test_subcat = TestSubcategory.find(params[:id])
      if !check_for_permission(test_subcat.test_category.organization_id, @current_user.id, [Role.dir_role, Role.sysadm_role])
        redirect_to test_categories_path, notice: I18n.t(:general_access_denied) + I18n.t(:security_subcategory_not_in_org)
      end
    end

end
