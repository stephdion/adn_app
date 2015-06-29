class EvalTypesController < ApplicationController

  before_filter :eval_types_permissions

  # GET /eval_types
  # GET /eval_types.json
  def index
    @eval_types = @current_organization.eval_types

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @eval_types }
    end
  end

  # GET /eval_types/1
  # GET /eval_types/1.json
  def show
    @eval_type = EvalType.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @eval_type }
    end
  end

  # GET /eval_types/new
  # GET /eval_types/new.json
  def new
    @eval_type = EvalType.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @eval_type }
    end
  end

  # GET /eval_types/1/edit
  def edit
    @eval_type = EvalType.find(params[:id])
  end

  # POST /eval_types
  # POST /eval_types.json
  def create
    @eval_type = EvalType.new(params[:eval_type].permit(:name, :organization_id))

    respond_to do |format|
      if @eval_type.save
        format.html { redirect_to eval_types_url, notice: I18n.t(:general_update_success) }
        format.json { render json: @eval_type, status: :created, location: @eval_type }
      else
        format.html { render action: "new" }
        format.json { render json: @eval_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /eval_types/1
  # PATCH/PUT /eval_types/1.json
  def update
    @eval_type = EvalType.find(params[:id])

    respond_to do |format|
      if @eval_type.update_attributes(params[:eval_type].permit(:name, :organization_id))
        format.html { redirect_to eval_types_url, notice: I18n.t(:general_update_success) }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @eval_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /eval_types/1
  # DELETE /eval_types/1.json
  def destroy
    @eval_type = EvalType.find(params[:id])
    @eval_type.destroy

    respond_to do |format|
      format.html { redirect_to eval_types_url }
      format.json { head :no_content }
    end
  end

  private

    # Use this method to whitelist the permissible parameters. Example:
    # params.require(:person).permit(:name, :age)
    # Also, you can specialize this method with per-user checking of permissible attributes.
    def eval_type_params
      params.require(:eval_type).permit(:name)
    end

    def eval_types_permissions
      # only ADN Sysadmin allowed to CRUD this data
      if !check_for_permission(0, 0, [0])
        redirect_to current_user, notice: I18n.t(:general_access_denied) + I18n.t(:security_not_ADN)
      end
    end

end
