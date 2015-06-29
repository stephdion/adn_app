class EquipeTypesController < ApplicationController
  include SessionsHelper

  before_filter :equipe_types_permissions, :only => [:index, :create, :new]
  before_filter :equipe_type_permissions, :only => [:show, :edit, :update, :destroy]
  

  def index
    @equipe_types = EquipeType.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @equipe_types }
    end
  end

  # GET /equipe_types/1
  # GET /equipe_types/1.json
  def show
    @equipe_type = EquipeType.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @equipe_type }
    end
  end

  # GET /equipe_types/new
  # GET /equipe_types/new.json
  def new
    @equipe_type = EquipeType.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @equipe_type }
    end
  end

  # GET /equipe_types/1/edit
  def edit
    @equipe_type = EquipeType.find(params[:id])
  end

  # POST /equipe_types
  # POST /equipe_types.json
  def create
    @equipe_type = EquipeType.new(params[:equipe_type])

    respond_to do |format|
      if @equipe_type.save
        format.html { redirect_to equipe_types_url, notice: I18n.t(:general_update_success) }
        format.json { head :no_content }
      else
        format.html { render action: "new" }
        format.json { render json: @equipe_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /equipe_types/1
  # PUT /equipe_types/1.json
  def update
    @equipe_type = EquipeType.find(params[:id])

    respond_to do |format|
      if @equipe_type.update_attributes(params[:equipe_type])
        format.html { redirect_to equipe_types_url, notice: I18n.t(:general_update_success) }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @equipe_type.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy

    EquipeType.find(params[:id]).destroy
    flash[:success] = "Sport/Activite supprime."
    redirect_to equipe_types_url

  end

  def equipe_types_permissions
      # only ADN Sysadmin, director, and sysadm allowed to view or create this data
      if !check_for_permission(@current_organization.id, @current_user.id, [Role.dir_role, Role.sysadm_role])
        redirect_to current_user, notice: I18n.t(:general_access_denied) + I18n.t(:security_not_DIR_SYSADM)
      end
    end

    def equipe_type_permissions
      # only ADN Sysadmin, director, and sysadm allowed to RUD this data
      equipe_type = EquipeType.find(params[:id])
      if !check_for_permission(equipe_type.organization_id, @current_user.id, [Role.dir_role, Role.sysadm_role])
        redirect_to equipe_types_path, notice: I18n.t(:general_access_denied) + I18n.t(:security_equipe_type_not_in_org)
      end
    end

end
