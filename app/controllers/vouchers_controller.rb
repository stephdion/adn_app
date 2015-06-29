class VouchersController < ApplicationController
  before_filter :vouchers_permissions

  def new
  end

  def destroy
    query = Voucher.where(:id => params[:id], :isSystem=>false)
    @voucher = query.first
    @voucher.destroy
    redirect_to :action => 'index'
  end

  def update
    params_voucher = params[:voucher]
    if Voucher.update_all({
                                   :token                 => params_voucher[:token],
                                   :description           => params_voucher[:description],
                                   :role_id               => params_voucher[:role_id],
                                   :organization_id       => params_voucher[:organization_id],
                                   :is_enabled             => params_voucher[:is_enabled],
                               },
                               {
                                   :id                 => params[:id]
                               })
      redirect_to Voucher.find(params[:id])
    else
      render 'show'
    end
  end

  def edit
    @voucher = Voucher.find(params[:id])
  end

  def create
    @voucher = Voucher.new(post_params)
    @voucher.role_id = params[:voucher][:role];
    @voucher.organization_id = params[:voucher][:organization];
    @voucher.is_enabled = params[:voucher][:is_enable];

    @voucher.save
    redirect_to @voucher
  end

  def show
    @voucher = Voucher.find(params[:id])
  end

  def index
    @vouchers = Voucher.paginate(page: params[:page])
  end

  private
  def post_params
    params.require(:voucher).permit(:token, :description, role_id: :role)
  end

  def vouchers_permissions
      # only ADN Sysadmin allowed to CRUD this data
      if !check_for_permission(0, 0, [0])
        redirect_to current_user, notice: I18n.t(:general_access_denied) + I18n.t(:security_not_ADN)
      end
    end

end
