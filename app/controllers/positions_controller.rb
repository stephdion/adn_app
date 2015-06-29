class PositionsController < ApplicationController

  before_filter :positions_permissions, :only => [:index, :create, :new]
  before_filter :position_permissions, :only => [:show, :edit, :update, :destroy]
  
  # GET /positions
  # GET /positions.json
  def index
    @positions = Position.order(:equipe_type_id)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @positions }
    end
  end

  # GET /positions/1
  # GET /positions/1.json
  def show
    @position = Position.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @position }
    end
  end

  # GET /positions/new
  # GET /positions/new.json
  def new
    @position = Position.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @position }
    end
  end

  # GET /positions/1/edit
  def edit
    @position = Position.find(params[:id])
  end

  # POST /positions
  # POST /positions.json
  def create
    organization_hash = {"organization_id" => @current_organization.id}
    @position = Position.new(params[:position].merge(organization_hash).permit(:equipe_type_id, :name))

    respond_to do |format|
      if @position.save
        format.html { redirect_to positions_path, notice: I18n.t(:general_update_success) }
         format.json { head :no_content }
      else
        format.html { render action: "new" }
        format.json { render json: @position.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /positions/1
  # PATCH/PUT /positions/1.json
  def update
    @position = Position.find(params[:id])

    respond_to do |format|
      if @position.update_attributes(params[:position].permit(:equipe_type_id, :name))
        format.html { redirect_to positions_path, notice: I18n.t(:general_update_success) }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @position.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /positions/1
  # DELETE /positions/1.json
  def destroy
    @position = Position.find(params[:id])
    if @position.participations.any?
      flash[:error] = I18n.t(:position_delete_failed)

      respond_to do |format|
      format.html { redirect_to positions_url }
      format.json { head :no_content }
      end
    else
    @position.destroy

    respond_to do |format|
      format.html { redirect_to positions_url }
      format.json { head :no_content }
    end
  end
  end

  private

    # Use this method to whitelist the permissible parameters. Example:
    # params.require(:person).permit(:name, :age)
    # Also, you can specialize this method with per-user checking of permissible attributes.
    def position_params
      params.require(:position).permit(:equipe, :position)
    end

    def positions_permissions
      # only ADN Sysadmin, director, and sysadm allowed to view or create this data
      if !check_for_permission(@current_organization.id, @current_user.id, [Role.dir_role, Role.sysadm_role])
        redirect_to current_user, notice: I18n.t(:general_access_denied) + ":pas ADN sysadmin ou SYSADM ou DIR"
      end
    end

    def position_permissions
      # only ADN Sysadmin, director, and sysadm allowed to RUD this data
      position = Position.find(params[:id])
      if !check_for_permission(position.equipe_type.organization_id, @current_user.id, [Role.dir_role, Role.sysadm_role])
        redirect_to positions_path, notice: I18n.t(:general_access_denied) + ": La position ne appartient pas a cet organisation"
      end
    end
end
