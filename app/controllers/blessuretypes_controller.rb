class BlessuretypesController < ApplicationController

  before_filter :blessure_permissions

  # GET /blessuretypes
  # GET /blessuretypes.json
  def index
    @blessuretypes = Blessuretype.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @blessuretypes }
    end
  end

  # GET /blessuretypes/1
  # GET /blessuretypes/1.json
  def show
    @blessuretype = Blessuretype.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @blessuretype }
    end
  end

  # GET /blessuretypes/new
  # GET /blessuretypes/new.json
  def new
    @blessuretype = Blessuretype.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @blessuretype }
    end
  end

  # GET /blessuretypes/1/edit
  def edit
    @blessuretype = Blessuretype.find(params[:id])
  end

  # POST /blessuretypes
  # POST /blessuretypes.json
  def create
    @blessuretype = Blessuretype.new(blessuretype_params)

    respond_to do |format|
      if @blessuretype.save
        format.html { redirect_to @blessuretype, notice: 'Blessuretype was successfully created.' }
        format.json { render json: @blessuretype, status: :created, location: @blessuretype }
      else
        format.html { render action: "new" }
        format.json { render json: @blessuretype.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /blessuretypes/1
  # PATCH/PUT /blessuretypes/1.json
  def update
    @blessuretype = Blessuretype.find(params[:id])

    respond_to do |format|
      if @blessuretype.update_attributes(blessuretype_params)
        format.html { redirect_to @blessuretype, notice: 'Blessuretype was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @blessuretype.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /blessuretypes/1
  # DELETE /blessuretypes/1.json
  def destroy
    @blessuretype = Blessuretype.find(params[:id])
    @blessuretype.destroy

    respond_to do |format|
      format.html { redirect_to blessuretypes_url }
      format.json { head :no_content }
    end
  end

  private

    # Use this method to whitelist the permissible parameters. Example:
    # params.require(:person).permit(:name, :age)
    # Also, you can specialize this method with per-user checking of permissible attributes.
    def blessuretype_params
      params.require(:blessuretype).permit(:code, :description, :name_fr)
    end

    def blessure_permissions
      # only ADN Sysadmin allowed to CRUD this data
      if !check_for_permission(0, 0, [0])
        redirect_to current_user, notice: I18n.t(:general_access_denied) + I18n.t(:security_not_ADN)
      end
    end
    
end
