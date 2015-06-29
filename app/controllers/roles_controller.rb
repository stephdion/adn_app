class RolesController < ApplicationController
  
  before_filter :roles_permissions

  def new
  end

  def destroy
    query = Role.where(:id => params[:id], :isSystem=>false)
    @role = query.first
    @role.destroy
    redirect_to :action => 'index'
  end

  def edit
    @role = Role.find(params[:id])
  end

  def update
    params_role = params[:role]
    if Role.update_all({
                           :name          => params_role[:name],
                           :description   => params_role[:description],
                           #:code          => params_role[:code],
                       },
                       {
                           :id            => params[:id]
                       })
      redirect_to Role.find(params[:id])
    else
      render 'edit'
    end

  end

  def create
    @role = Role.new(post_params)

    @role.save
    redirect_to @role
  end

  def show
    @role = Role.find(params[:id])
  end

  def index
    @roles = Role.paginate(page: params[:page])
  end

private
  def post_params
    params.require(:role).permit(:name, :description, :code)
  end

  def roles_permissions
      # only ADN Sysadmin allowed to CRUD this data
      if !check_for_permission(0, 0, [0])
        redirect_to current_user, notice: I18n.t(:general_access_denied) + I18n.t(:security_not_ADN)
      end
    end

end
