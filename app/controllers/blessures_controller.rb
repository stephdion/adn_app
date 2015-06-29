class BlessuresController < ApplicationController

  #anyone can create a blessure report
  before_filter :index_blessure_permissions,          :only => [:index]
  before_filter :show_update_blessure_permissions,    :only => [:show, :update, :edit]
  #before_filter :deny_blessure_delete,                :only => [:destroy]

  def destroy
    query = Blessure.where(:id => params[:id])
    @blessure = query.first
    @blessure.destroy
    redirect_to :action => 'index'
  end

  def index
    if @current_role == (Role.trainer_role || Role.physio_role)
      athletes = @current_user.current_team_members.map(&:id).to_a
    else
      athletes = @current_organization.users.map(&:id).to_a
    end
    @blessures= Blessure.where("user_id IN (?) AND (original_report_id = 0 OR original_report_id IS NULL)", athletes).order("date DESC").paginate(page: params[:page])

  end

  def new
    @blessure = Blessure.new
    get_allowed_athletes
  end

  def edit
    @blessure = Blessure.find(params[:id])
    @allowed_athletes = [@blessure.user]
  end

  def show
    @blessure = Blessure.find(params[:id])
    if !(@blessure.original_report_id == 0 || @blessure.original_report_id.nil?)
      @blessure = Blessure.find(@blessure.original_report_id)
    end
  end


  def update
    @old_blessure = Blessure.find(params[:id])
    @blessure = Blessure.find(params[:id])

    @blessure.symptomes = params[:blessure][:symptomes]
    @blessure.update_attributes(blessure_params)
    year = params[:blessure]['date(1i)'].to_i
    month = params[:blessure]['date(2i)'].to_i
    day = params[:blessure]['date(3i)'].to_i
    if year!=0 && month!=0 && day !=0
      @blessure.date = Date.civil(params[:blessure]['date(1i)'].to_i,
                                  params[:blessure]['date(2i)'].to_i,
                                  params[:blessure]['date(3i)'].to_i)
    end
    # if (@old_blessure.original_report_id == 0 || @old_blessure.original_report_id.nil?)
    #   @blessure.original_report_id = @old_blessure.id
    #   @original_blessure = Blessure.find(@old_blessure.id)
    # else
    #   @blessure.original_report_id = @old_blessure.original_report_id
    #   @original_blessure = Blessure.find(@old_blessure.original_report_id)
    # end

    @blessure.reporter_id = @current_user.id
    
    ##LINKER
    @blessure.body_part_id = Bodypart.where(code: params[:blessure][:partie_du_corp]).first[:id]
    if params[:blessure][:cote_du_corp] != "" 
      @blessure.body_side_id = Bodyside.where(code: params[:blessure][:cote_du_corp]).first[:id]
    end
    if params[:blessure][:type_de_blessure] != "" 
      @blessure.blessure_type_id = Blessuretype.where(code: params[:blessure][:type_de_blessure]).first[:id]
    end
    if params[:blessure][:operation] != ""
      @blessure.blessure_operation_id = BlessureOperation.where(code: params[:blessure][:operation]).first[:id]
    end
    if params[:blessure][:surface] != ""
      @blessure.blessure_surface_id = BlessureSurface.where(code: params[:blessure][:surface]).first[:id]
    end
    if params[:blessure][:mechanism] != ""
      @blessure.blessure_mechanism_id = BlessureMechanism.where(code: params[:blessure][:mechanism]).first[:id]
    end

    if params[:blessure][:equipe_id] != "0"
      @blessure.equipe = Equipe.find(params[:blessure][:equipe_id])
    end
    if params[:blessure][:equipe_id] != "0"
      @blessure.equipe = Equipe.find(params[:blessure][:equipe_id])
    end

    if @blessure.save
      render :action => 'show'
    else
      render :action => 'show'
    end
  end

  def create
    @blessure = Blessure.new(blessure_params)
    @blessure.symptomes = params[:blessure][:symptomes]
    year = params[:blessure]['date(1i)'].to_i
    month = params[:blessure]['date(2i)'].to_i
    day = params[:blessure]['date(3i)'].to_i
    if year!=0 && month!=0 && day !=0
      @blessure.date = Date.civil(params[:blessure]['date(1i)'].to_i,
                                  params[:blessure]['date(2i)'].to_i,
                                  params[:blessure]['date(3i)'].to_i)
    end
    @blessure.original_report_id = 0
    @blessure.reporter_id = @current_user.id

    ##LINKER
    if params[:blessure][:partie_du_corp] != "" 
      @blessure.body_part_id = Bodypart.where(code: params[:blessure][:partie_du_corp]).first[:id]
    end
    if params[:blessure][:cote_du_corp] != "" 
      @blessure.body_side_id = Bodyside.where(code: params[:blessure][:cote_du_corp]).first[:id]
    end
    if params[:blessure][:type_de_blessure] != "" 
      @blessure.blessure_type_id = Blessuretype.where(code: params[:blessure][:type_de_blessure]).first[:id]
    end
    if params[:blessure][:operation] != ""
      @blessure.blessure_operation_id = BlessureOperation.where(code: params[:blessure][:operation]).first[:id]
    end
    if params[:blessure][:surface] != ""
      @blessure.blessure_surface_id = BlessureSurface.where(code: params[:blessure][:surface]).first[:id]
    end
    if params[:blessure][:mechanism] != ""
      @blessure.blessure_mechanism_id = BlessureMechanism.where(code: params[:blessure][:mechanism]).first[:id]
    end

    if params[:blessure][:equipe_id] != "0"
      @blessure.equipe = Equipe.find(params[:blessure][:equipe_id])
    end

    if @blessure.save
      redirect_to @blessure
    else
      render 'new'
    end
  end

  def ajax_get_equipe
    equipes = Equipe.joins(:participations).where("participations.user_id = ?", params[:blessure_id])

    @value_team = ""
    equipes.each do |equipe|
      @value_team << "<option value='" << equipe.id.to_s << "'>" << equipe.name << "</option>"
    end
    respond_to do |format|
      format.json { render json: @value_team }  # respond with the created JSON object
    end
  end

  private
  def blessure_params
    params.require(:blessure).permit(:date, :user_id, :equipe_type_id, :equipe_id, :partie_du_corp,
                                     :cote_du_corp, :type_de_blessure,
                                     :mechanism, :surface, :retour_au_jeu,
                                     :symptomes, :detail, :operation, :operation_date)
  end

  def get_allowed_athletes
    if is_current_user_in_role?('ATHLETE')
      @allowed_athletes = [current_user]
    elsif is_current_user_in_role?('PARENT')
      @allowed_athletes = current_user.children
    else
      @allowed_athletes = User.in_organization(["ATHLETE"])
    end
  end

  def index_blessure_permissions
    # only staff can look at the blessures index
    if !check_for_permission(@current_organization.id, @current_user.id, [Role.dir_role, Role.sysadm_role, Role.trainer_role, Role.physio_role])
          redirect_to current_user, notice: I18n.t(:general_access_denied) + I18n.t(:security_PARENT_ATHLETE_deny)
    end

  end

  def show_update_blessure_permissions
    # only staff and owner can look at the blessure
    @blessure = Blessure.find(params[:id])
    user_has_permission = true

    if @blessure.user_id == @current_user.id # if this is the athlete who was injured OK
      user_has_permission = true
    elsif @current_user.children.include?(@blessure.user) # If this is the parent of the athlete who was injured OK
      user_has_permission = true
    elsif @current_role == (Role.trainer_role || Role.physio_role) # if this is a trainer or physio that trains the athlete who was injured OK
      athletes = @current_user.current_team_members
      if athletes.include?(@blessure.user)
        user_has_permission = true
      end
    else
      @blessure.user.organizations.each do |organization| # if this is a director or sysadmin who belongs to the same org as the athlete who was injured OK
        if check_for_permission(organization.id, @current_user.id, [Role.dir_role, Role.sysadm_role])
          user_has_permission = true
        end
      end
    end

    if !user_has_permission
      redirect_to current_user, notice: I18n.t(:general_access_denied) + I18n.t(:security_blessure_not_in_org)
    end
  end

  def deny_blessure_delete
    #blessure records should never be erased
    redirect_to current_user, notice: I18n.t(:general_access_denied) + I18n.t(:security_blessure_delete_deny)
  end

  def is_blessure_owner_or_admin?
    if current_user.id != Blessure.find(params['id']).user_id &&
            is_current_user_in_role?("ATHLETE")
        redirect_to ouverture_url, notice: I18n.t(:general_access_denied)
    end
  end

end
