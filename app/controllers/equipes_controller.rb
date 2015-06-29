class EquipesController < ApplicationController
  include SessionsHelper

  before_filter :create_index_equipe_permissions,   :only => [:new, :create, :index]
  before_filter :show_equipe_permissions,           :only => [:show]
  before_filter :update_equipe_permissions,         :only => [:edit, :update]
  before_filter :delete_equipe_permissions,         :only => [:destroy]

  def new
    @equipe = Equipe.new
    @equipe.organization_id = @current_organization.id
  end

  def edit
    @equipe = Equipe.find(params[:id])
    @participants = Participation.equipe_participants(@equipe.id)
  end

  def create
    @equipe = current_user.admin_equipes.build(params[:equipe].permit(:name, :organization_id, :description, :equipe_type_id))
    if @equipe.save
      flash[:success] = I18n.t(:equipe_add_participants)
      @participants = Participation.equipe_participants(@equipe.id)
      render 'edit'
    else
      render 'new'
    end
  end

  def show 
    @equipe = Equipe.find(params[:id])
    @athletes = @equipe.get_members(Role.athlete_role)
    @trainers = @equipe.get_members(Role.trainer_role)
    @physios = @equipe.get_members(Role.physio_role)
    @resultats = Resultat.where(:equipe_id => params[:id]).
                          select("date(created_at) as eval_day, 
                                  evaluation_id,
                                  min(user_id) as user_id, 
                                  min(id) as resultat_id,
                                  sum((value + left_side%100)*component) as score").
                          group("eval_day, evaluation_id").
                          order("eval_day ASC")
      @record_count = 0
      @resultats.each do |resultat|
      @record_count += 1
    end
  end

  def index
    @equipes = @current_organization.equipes
  end

  def update
    @equipe = Equipe.find(params[:id])
    if (params[:user] and is_current_user_sysadmin?)
      @equipe.user = User.find(params[:user][:id])
    end
    if @equipe.update_attributes(params[:equipe].permit(:name, :organization_id, :user_id, :description, :equipe_type_id, :user_ids))
      check_participants(params[:equipe][:user_ids], @equipe.id)
      flash[:success] = I18n.t(:equipe_modified)
      redirect_to @equipe
    else
      render 'edit'
    end
  end

  def destroy
    Equipe.find(params[:id]).destroy
    flash[:success] = I18n.t(:equipe_deleted)
    redirect_to equipes_url
  end

  private

  def correct_user_for_equipe(equipe)
    if equipe.user
        if @current_user == equipe.user
          return true
        else
          return false
        end
    else
      return false
    end
  end

  def check_participants(user_ids, team_id)
    user_ids.delete_at(0)
    current_participants = Participation.where("equipe_id = ?", team_id)
    
    array_current_part = Array.new
    current_participants.each do |current|
      array_current_part << current.user_id

      if !user_ids.include? current.user_id.to_s
        current.destroy
      end
    end

    user_ids.each do |id|
      if !array_current_part.include? id
        Participation.new(user_id: id, equipe_id: team_id).save
      end
    end
  end

  def create_index_equipe_permissions
    # Everyone in the organization can create a team or see the index except Parents and Athletes
    if !check_for_permission(@current_organization.id, @current_user.id, [Role.dir_role, Role.sysadm_role, Role.trainer_role, Role.physio_role])
      redirect_to current_user, notice: I18n.t(:general_access_denied) + I18n.t(:security_PARENT_ATHLETE_deny)
    end
  end

  def show_equipe_permissions
    # everyone in org can look at the teams
    @equipe = Equipe.find(params[:id])
    if !check_for_permission(@equipe.organization_id, @current_user.id, [Role.dir_role, Role.sysadm_role, Role.trainer_role, Role.physio_role, Role.parent_role, Role.athlete_role])
      redirect_to current_user, notice: I18n.t(:general_access_denied) + I18n.t(:security_equipe_not_in_org)
    end
  end

  def update_equipe_permissions
    # only owner, sysadmin and dir can update the teams
    @equipe = Equipe.find(params[:id])
    if !check_for_permission(@equipe.organization_id, @current_user.id, [Role.dir_role, Role.sysadm_role]) && !correct_user_for_equipe(@equipe)
      redirect_to equipes_path, notice: I18n.t(:general_access_denied) + I18n.t(:security_not_DIR_SYSADM_owner)
    end
  end

  def delete_equipe_permissions
    # only owner, sysadmin and dir can delete a team
    update_equipe_permissions
    # don't delete teams with participations
    if @equipe.participations.any?
      redirect_to @equipe, notice: I18n.t(:general_access_denied) + I18n.t(:security_equipe_delete_deny)
    end
  end
  
end