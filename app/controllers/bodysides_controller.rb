class BodysidesController < ApplicationController

  before_filter :bodyside_permissions


  # GET /bodysides
  # GET /bodysides.json
  def index
    @bodysides = Bodyside.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @bodysides }
    end
  end

  # GET /bodysides/1
  # GET /bodysides/1.json
  def show
    @bodyside = Bodyside.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @bodyside }
    end
  end

  # GET /bodysides/new
  # GET /bodysides/new.json
  def new
    @bodyside = Bodyside.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @bodyside }
    end
  end

  # GET /bodysides/1/edit
  def edit
    @bodyside = Bodyside.find(params[:id])
  end

  # POST /bodysides
  # POST /bodysides.json
  def create
    @bodyside = Bodyside.new(bodyside_params)

    respond_to do |format|
      if @bodyside.save
        format.html { redirect_to @bodyside, notice: 'Bodyside was successfully created.' }
        format.json { render json: @bodyside, status: :created, location: @bodyside }
      else
        format.html { render action: "new" }
        format.json { render json: @bodyside.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bodysides/1
  # PATCH/PUT /bodysides/1.json
  def update
    @bodyside = Bodyside.find(params[:id])

    respond_to do |format|
      if @bodyside.update_attributes(bodyside_params)
        format.html { redirect_to @bodyside, notice: 'Bodyside was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @bodyside.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bodysides/1
  # DELETE /bodysides/1.json
  def destroy
    @bodyside = Bodyside.find(params[:id])
    @bodyside.destroy

    respond_to do |format|
      format.html { redirect_to bodysides_url }
      format.json { head :no_content }
    end
  end

  private

    # Use this method to whitelist the permissible parameters. Example:
    # params.require(:person).permit(:name, :age)
    # Also, you can specialize this method with per-user checking of permissible attributes.
    def bodyside_params
      params.require(:bodyside).permit(:code, :description, :name_fr)
    end

    def bodyside_permissions
      # only ADN Sysadmin allowed to CRUD this data
      if !check_for_permission(0, 0, [0])
        redirect_to current_user, notice: I18n.t(:general_access_denied) + I18n.t(:security_not_ADN)
      end
    end

end
