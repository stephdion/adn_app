class BodypartsController < ApplicationController

  before_filter :bodypart_permissions

  # GET /bodyparts
  # GET /bodyparts.json
  def index
    @bodyparts = Bodypart.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @bodyparts }
    end
  end

  # GET /bodyparts/1
  # GET /bodyparts/1.json
  def show
    @bodypart = Bodypart.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @bodypart }
    end
  end

  # GET /bodyparts/new
  # GET /bodyparts/new.json
  def new
    @bodypart = Bodypart.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @bodypart }
    end
  end

  # GET /bodyparts/1/edit
  def edit
    @bodypart = Bodypart.find(params[:id])
  end

  # POST /bodyparts
  # POST /bodyparts.json
  def create
    raise bodypart_params.to_s
    @bodypart = Bodypart.new(bodypart_params)

    respond_to do |format|
      if @bodypart.save
        format.html { redirect_to @bodypart, notice: 'Bodypart was successfully created.' }
        format.json { render json: @bodypart, status: :created, location: @bodypart }
      else
        format.html { render action: "new" }
        format.json { render json: @bodypart.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bodyparts/1
  # PATCH/PUT /bodyparts/1.json
  def update
    @bodypart = Bodypart.find(params[:id])

    respond_to do |format|
      if @bodypart.update_attributes(bodypart_params)
        format.html { redirect_to @bodypart, notice: 'Bodypart was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @bodypart.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bodyparts/1
  # DELETE /bodyparts/1.json
  def destroy
    @bodypart = Bodypart.find(params[:id])
    @bodypart.destroy

    respond_to do |format|
      format.html { redirect_to bodyparts_url }
      format.json { head :no_content }
    end
  end

  private

    # Use this method to whitelist the permissible parameters. Example:
    # params.require(:person).permit(:name, :age)
    # Also, you can specialize this method with per-user checking of permissible attributes.
    def bodypart_params
      params.require(:bodypart).permit(:code, :description, :name_fr)
    end

    def bodypart_permissions
      # only ADN Sysadmin allowed to CRUD this data
      if !check_for_permission(0, 0, [0])
        redirect_to current_user, notice: I18n.t(:general_access_denied) + I18n.t(:security_not_ADN)
      end
    end

end
