class OrganizationsController < ApplicationController
  
  before_filter :organizations_permissions, :except => [:set_current]

  def new

  end


  def destroy
    query = Organization.where(:id => params[:id], :isSystem=>false)
    @organization = query.first
    @organization.destroy
    redirect_to :action => 'index'
  end

  def update
    params_org = params[:organization]
    if Organization.update_all({
                           :name               => params_org[:name],
                           :description        => params_org[:description],
                       },
                       {
                           :id                 => params[:id]
                       })
      redirect_to Organization.find(params[:id])
    else
      render 'show'
    end
  end

  def edit
    @organization = Organization.find(params[:id])
  end

  def create
    @organization = Organization.new(post_params)

    @organization.save
    redirect_to @organization
  end

  def show
    @organization = Organization.find(params[:id])
  end

  def index
    @organizations = Organization.paginate(page: params[:page])
  end

  def set_current
    if @current_user.organizations.map(&:id).include?(params[:id].to_i)
      session[:organization_id] = params[:id]
      redirect_to :back
    else
      redirect_to current_user, notice: I18n.t(:general_access_denied) + I18n.t(:security_user_not_in_org)
    end
  end

  private
  def post_params
    params.require(:organization).permit(:name, :description)
  end


   def organizations_permissions
      # only ADN Sysadmin allowed to CRUD this data
      if !check_for_permission(0, 0, [0])
        redirect_to current_user, notice: I18n.t(:general_access_denied) + I18n.t(:security_not_ADN)
      end
    end

end
