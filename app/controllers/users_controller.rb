class UsersController < ApplicationController
  include SessionsHelper
  include EmailHelper
  include UsersHelper
  include BlessuresHelper
  include RolesHelper
  include StatisticsHelper
  include AuthorizationHelper
  include ApplicationHelper

  before_filter :deny_athletes_and_parents, only: [:index]
  before_filter :is_current_user_sysadmin?, only: [:addUser, :destroy]
  before_filter :edit_privileges, only: [:edit, :update]
  before_filter :authorization_profile_page, only: [:show]
  skip_before_filter :signed_in_user, only:[:update_temporary]

  @@defaultPassword = nil
  @@defaultRole_id = nil
  @@defaultOrg_id = nil


  def index
    if params[:role] && params[:role] != ""
      role = Role.find(params[:role]).code
    else
      role = "ALL"
    end

    if params[:search] && params[:search] != ""
      @users = User.page(params[:page]).in_organization([role]).order(last_name: :asc).search params[:search]
    else
      @users = User.page(params[:page]).in_organization([role]).order(last_name: :asc)
    end
      
  end

  def new
    @user = User.new
  end

  def change_password
    @user = User.find(params[:id])
  end

  def update_password
    @user = User.find(params[:id])
    if current_user?(@user)
      login_after_save = true
    else
      login_after_save = false
    end
    @user.update_attributes(user_params)
    @user.registration_token = nil
    @user.is_enabled = true
    @user.change_password_required = false
    if @user.save
      flash[:success] = I18n.t(:general_password_updated)
      if login_after_save
        sign_in @user
      end
      redirect_to @user
    else
      flash[:success] = I18n.t(:general_failure)
      #render :action => 'edit'

      errorMessage = nil
      if @user.errors && @user.errors.messages &&
          @user.errors.messages[:password] &&
          @user.errors.messages[:password][0]
        errorMessage = @user.errors.messages[:password][0]
      end
      #redirect_to '/user_registration/' + @user.registration_token, :flash => { :error => errorMessage }

      redirect_to request.referer, :flash => { :error => errorMessage }
    end
  end

  def destroy
    query = User.where(:id => params[:id])
    @user = query.first
    if(@user.deleted == 0)
      @user.deleted = 1
    else
      @user.deleted = 0
    end
    @user.save
    #@user.destroy
    redirect_to :action => 'index'
  end

  def addUser
    @user = User.new
    @user.memberships.build
    @user.change_password_required = true
    @user.is_enabled = false
  end

  def addUser_save
  @user = User.new(params[:user].permit(:last_name,
    :first_name, :email, :password, :change_password_required, :is_enabled, :memberships_attributes))
  @user.password_confirmation = @user.password
  memberships = params[:user][:memberships_attributes][:"0"]
  if(params[:user][:is_enabled].nil?)
    @user.is_enabled = false
  end
  if @user.save
    @membership = Membership.new(role_id: memberships[:role_id], user_id: @user.id, organization_id: memberships[:organization_id])
    @membership.save

    if(params[:parent])
      params[:parent].each do |parent|
        parent[:password] = "solutionadn"
        parent[:is_enabled] = true
        parent[:change_password_required] = true
        newParent = User.new(parent.permit(:last_name,:first_name,:email,:password,:change_password_required,:is_enabled, :memberships_attributes))
        newParent.password_confirmation = newParent.password

        memberships = params[:user][:memberships_attributes][:"0"]
        memberships[:role_id] = 2
        if newParent.save
          newMembership = Membership.new(role_id: memberships[:role_id], user_id: newParent.id, organization_id: memberships[:organization_id])
          newMembership.save
          newFamMember = FamilyMember.new(user_id: @user.id, parent_id: newParent.id, relationship: parent[:relationship])
          newFamMember.save
        end
      end
    end

    redirect_to action: 'index', notice: I18n.t(:user_added)
  else
  render 'addUser'
end
  end

  def update_temporary
    @user = User.find(params[:id])
    @user.email = nil

    paramusers = params[:user]
    if paramusers
      @user.update_attributes(paramusers.permit(:last_name,
    :first_name, :email, :password, :password_confirmation))
      if @user.is_temporary?
        @user.email = nil
      end
      @user.change_password_required=false;
      @user.registration_token = SecureRandom.urlsafe_base64
      if @user.save
        flash[:success] = I18n.t(:user_necessary_info)
        sign_in @user
        @registrationUrl = request.protocol + request.host_with_port + '/user_registration/' + @user.registration_token
        msg = @@REGISTRATION_CONTENT % [@user.name, @user.email ,@registrationUrl, @registrationUrl]
        send_email(@user.email, msg)
        redirect_to '/user_registered'
        #msg = @@REGISTRATION_CONTENT % [@user.name, @user.email]
        #send_email(@user.email, msg)
        #new_phone_email_anthro
        #render 'edit'
      end
    end
  end

  def update_address
    @user = User.find(params[:id])

    if params[:user]
      paramusers = user_params
      @user.update_attributes(paramusers)
      process_phones @user, params[:user][:user_phones_attributes]
      if !@user.has_address? or !@user.has_phones?
        flash[:error] = "Il faut fournir une address civil et un numero de telephone."
        1.times { @user.user_phones         .build }
        1.times { @user.user_emails         .build }
      elsif @user.save
        flash[:success] = I18n.t(:user_information_updated)
        sign_in @user
        redirect_to user_path :id => @user.id
      end
    elsif
      1.times { @user.user_phones         .build }
      1.times { @user.user_emails         .build }
    end
  end

  def show
    ##Permision test
    if have_access_to_profil(params[:id])
      #if user hasn't given us his address or phone number - direct him to the edit page
      @user = User.includes(:programmes, :evaluations).find(params[:id])
      if current_user?(@user) && (!@user.has_address? or !@user.has_phones?)
        new_phone_email_anthro_membership
        flash.now[:error] = I18n.t(:user_address_info_missing)
        render 'edit'
      elsif current_user?(@user) && @user.change_password_required?
        render 'change_password'
      else
        @resultats = Resultat.where(:athlete_id => params[:id]).
        select("date(created_at) as eval_day,
          MIN(id) as id,
          evaluation_id,
          user_id,
          date(created_at) as created_at,
          equipe_id,
          athlete_id,
          MIN(id) as record_id,
          sum((value + left_side%100)*component) as score").
        group("athlete_id,eval_day, evaluation_id, user_id, equipe_id").
        order("eval_day DESC")

        @participe_equipes = @user.participations
        @admin_equipes = Equipe.where(:user_id => @user.id)
        if is_user_in_role?(@user, 'DIR')
          collect_director_stats
        end
        if is_user_in_any_role?(@user, ['TRAINER', 'PHYSIO'])
          collect_trainer_stats
        end

        if params[:commit] == I18n.t(:search_refresh_resultats)
          @jump_to_resultats = true
        else
          @jump_to_resultats = false
        end

        team_panel_info("0")

        @mails = MailUser.where(:uid_to => @current_user.id).order('date_created desc').limit(5)
        @address_trainers = @user.trainers#User.in_organization(["TRAINER"])#.in_organization(["ALL"])
        @address_physios = @user.physios#User.in_organization(["PHYSIO"])#.in_organization(["ALL"])
        @address = @address_trainers + @address_physios

        @address.sort_by!{|e| e.first_name.downcase}
        @timelineArray = Array.new
        @user.blessures.each do |blessure|
          #@timelineArray.push(blessure)
          @timelineArray.push(:title => blessure.title_wo_date, :description => blessure.detail, :css => "warning", :icon =>"fontello-broken28", :option => nil, :date => blessure.date)
        end

        @resultats.each_with_index do |resultat,index|

          @res_record = Resultat.find(resultat.id)
          timestamp = @res_record.created_at
          eval_id = @res_record.evaluation_id
          evaluator = @res_record.user_id
          equipe_id = @res_record.equipe_id
          @resultats_all = Resultat.index_detail(eval_id, evaluator, equipe_id, timestamp)
          if @res_record.evaluation
            evaluation = Evaluation.find(eval_id)
            @maximum_score = evaluation.maximum_score
          else
            @maximum_score = 0
          end
          if resultat.score.to_i <= @maximum_score 
             resultatz = resultat.score
          else
            next
            resultatz = I18n.t(:resultats_incomplete)
          end
          #@timelineArray.push(ex)
          @timelineArray.push(:title => "#{resultat.evaluation.name}", :description => "Score : #{resultatz}", :css => "success", :icon =>"fontello-running31", :option => nil, :date => resultat.eval_day)
        end
        @user.programmes.each do |prog|
          #@timelineArray.push(prog)
          @timelineArray.push(:title => prog.name, :description => prog.description, :css => nil, :icon =>"glyphicon glyphicon-check", :option => nil, :date => prog.updated_at)
        end
        @user.evaluations.each do |eval|
          #@timelineArray.push(eval)
          @timelineArray.push(:title => eval.name, :description => eval.description, :css => "info", :icon =>"fontello-logo", :option => nil, :date => eval.updated_at)
        end
        @user.scat2s.each do |scat|
          #@timelineArray.push(scat)
          @timelineArray.push(:title => "SCAT2", :description => "hardcoded description, replace in users_controller", :css => "danger", :icon =>"fontello-bald7", :option => nil, :date => scat.evaluation_datetime)
        end
        @timelineArray.sort! { |a,b| b[:date] <=> a[:date]}
        #@timelineArray.sort_by{|timeline| timeline[:date]}
        #@timelineArray.reverse!

        info_physique
        info_eval
        info_prog
      end
    else
      redirect_to action: "show", id: current_user.id
    end
  end

  def info_prog
    @progArray = Array.new

    if @user.programmes.any?
      @user.programmes.each do |prog|
        if prog.exercises.any?
          prog.exercises.each do |exer|
            #if exer.organization_id == @current_organization.id && exer.user_id == @user.id
            if exer.user_id == @user.id
              # if @progArray.find{|e| e[:id] == prog.id} == nil
                @progArray.push(:id => prog.id)
              # end
            end
          end
        end
      end
    end
  end

  def info_eval
  @evalArray = Array.new
  eval_test = []
  @eval_badge = 0
  flag_autre = 0

  @resultats.each do |resultat|
    eval_test += Resultat.get_evaluation_results(resultat.evaluation_id, resultat.user_id,
                          resultat.athlete_id, nil, resultat.created_at,
                          1.minute, "test_order")
  end
    if eval_test.any?
      eval_test.each do |eval|
        if eval.evaluation.eval_type_id != nil && EvalType.exists?(:id => eval.evaluation.eval_type_id) #&& eval.evaluation.organization_id == @current_organization.id#&& eval.evaluation.user_id == @user.id
          if @evalArray.find{|e| e[:id] == EvalType.find(eval.evaluation.eval_type_id).id} == nil
            @evalArray.push(:id => EvalType.find(eval.evaluation.eval_type_id).id, :name => EvalType.find(eval.evaluation.eval_type_id).name)
          end
        else
          if @evalArray.find{|e| e[:id] == -1} == nil && flag_autre == 0 #&& eval.evaluation.organization_id == @current_organization.id
            flag_autre = 1
          end
        end
        if eval.component == 0 && eval.evaluation.organization_id == @current_organization.id
          @eval_badge += 1
        end
      end
    end

  if flag_autre == 1
    @evalArray.push(:id => -1, :name => "Autre")
  end
  end

  def info_physique
  if @user.blessures.any?
    @info_blessure = ""
    @retour = DateTime.now.to_date;
    @user.blessures.each do |blessure|
      @info_blessure << blessure.title_wo_date + ' / '
      if blessure.retour_au_jeu != 'f'# && @retour < blessure.retour_au_jeu
        @retour = blessure.retour_au_jeu
      end
    end
    @info_blessure = "Blesse" #: " + @info_blessure[0..-4]
  else
    @info_blessure = t 'general_no_injury'
    @retour = t 'general_no_injury'
  end

  @profileTeam = Participation.where(:user_id => @user.id).
        select("equipe_id,
            position_id").
        group("equipe_id, position_id").
        order("equipe_id ASC")

  if @profileTeam.any?
    @info_sports = ""
    @profileTeam.each do |equipe|
      if equipe[:position_id] #&& Organization.find(Equipe.find(equipe[:equipe_id]).organization_id) == @current_organization
        @info_sports << Position.find(equipe[:position_id]).name  + ' - ' + EquipeType.find(Equipe.find(equipe[:equipe_id]).equipe_type_id).name + ' // '
      end
    end
    @info_sports = @info_sports[0..-5]
  end
  end

  def edit
    @user = User.find(params[:id])
    new_phone_email_anthro_membership
  end

  def update
    @user = User.find(params[:id])
    @user.update_attributes(user_params)
    update_age

    process_phones @user, params[:user][:user_phones_attributes]

    process_emails @user, params[:user][:user_emails_attributes]

    process_memberships @user, params[:user][:memberships_attributes]

    process_family_members @user, params[:user][:family_members_attributes]

    update_anthropometrics

    if @user.save
      flash[:success] = I18n.t(:user_information_updated)
      if current_user?(@user)
        sign_in @user
      end
      session[:organization_id] = @user.organizations.first.id
    end
    redirect_to user_path @user
  end


  def registration
    @user = User.find_by_registration_token(params[:token])
    if @user
      if(!@user.change_password_required)
        @user.update_attribute('registration_token', nil)
        flash.now[:success] = I18n.t(:user_welcome_adn)
      end
    else
      flash.now[:error] = I18n.t(:user_unknown_activation_link)
    end
  end

  def create
    query = Voucher.where(:token => params[:voucher])
    @user = User.new(user_params)
    membership = Memberships.new(role_id: @voucher.role.id, user_id: @user.id, membership_id: @voucher.organization.id)
    membership.save
    @user.is_enabled = false;
    if(query.length>0)
      @voucher = query.first
      #@user.memberships.build(:role_id => @voucher.role.id, :organization_id => @voucher.organization.id)
      @user.registration_token = SecureRandom.urlsafe_base64
      if @user.save
        @registrationUrl = request.protocol + request.host_with_port + '/user_registration/' + @user.registration_token
        msg = @@REGISTRATION_CONTENT % [@user.name, @user.email ,@registrationUrl, @registrationUrl]
        send_email(@user.email, msg)

        session[:registrationUrl] = @registrationUrl
        redirect_to '/user_registered'
      else
        render 'new'
      end
    else
      @user.errors[:base]  << I18n.t(:user_voucher_missing)
      render 'new'
    end
  end

  def search
    redirect_to :action => "index", :search=> params[:search], :role => params[:role]
  end

  def scat2s
    @user = User.find(params[:id])
    return @user;
  end

  def report
    @user = User.find(params[:id])
    @reportHistoryList = ReportHistory.where(:user_id => @user.id).order(id: :DESC)
    @reportTaskList = ReportTask.where(:user_id => @user.id, :deleted => 0).order(report_type: :ASC, frequency: :ASC)
  end

  def report_delete
      returnValue = "0"
      if(params.include?(:id))
        report = ReportTask.find(params[:id])
        report.deleted = 1
        report.save
        returnValue = "1"
      end

      respond_to do |format|
        format.json  { render :json => returnValue}
      end
  end

  def video
    @user = User.find(params[:id])
    mails = MailUser.where(:uid_to => params[:id]).order(:date_created)
    @videoList = Array.new

    if !mails.nil?
      mails.each do |mail|
        if !mail.linkyt.nil? && mail.linkyt != ""
          if validate_link(mail.linkyt)
            @videoList.push(mail.linkyt)
          end
        end
      end
    end
  end

  def programs
    @user = User.find(params[:id])
    mails = MailUser.where(:uid_to => params[:id]).order(:date_created)
    @programList = Array.new
    @pdfProgram = Array.new
    @resultats = Resultat.where(:athlete_id => params[:id]).
        select("date(created_at) as eval_day,
          MIN(id) as id,
          evaluation_id,
          user_id,
          date(created_at) as created_at,
          equipe_id,
          athlete_id,
          MIN(id) as record_id,
          sum((value + left_side%100)*component) as score").
        group("athlete_id,eval_day, evaluation_id, user_id, equipe_id").
        order("eval_day DESC")
    if !mails.nil?
      mails.each do |mail|
        if !mail.program.nil? && mail.program != "" && mail.program != 0
          if !@programList.include?(mail.program)
            @programList.push(mail.program)
          end
        end
        if(mail.file_program == 1 && !mail.file_name.nil? && mail.file_name.split(".").last == "pdf")
          @pdfProgram.push(:id => mail.id, :name=>mail.file_name, :hash => mail.file_hash)
        end
      end
    end
  end

  def send_report
    if(params.include?(:id))
      report = ReportHistory.where(:id => params[:id]).first
      if(!report.nil?)
        @user = User.where(:id=> report.user_id).first
        if(!@user.nil? && @user.id == @current_user.id)
          @participe_equipes = @user.equipes
          @admin_equipes = Equipe.where(:user_id => @user.id)

          if !(report.equipe_select == "0" || report.equipe_select == nil)
            selected_teams_params = report.equipe_select.split(',')
              if selected_teams_params.is_a? Array
                  params[:multi_equipe_select] = selected_teams_params #only declare injuries for the specified team
              else
                  params[:multi_equipe_select] = selected_teams_params.to_i
                  params[:equipe_select] = report.equipe_select
              end          
          end
          saveOrg = @current_organization
          Organization.current_organization = report.organization_id
          #localhost:3000/users/report/700?type=1&end_date_eval%5B%5D=2015-02-01&start_date_eval%5B%5D=2013-02-01&evaluation%5B%5D=2&evaluation%5B%5D=25&eval_test_id=&multi_equipe_select%5B%5D=69&multi_equipe_select%5B%5D=71&multi_equipe_select%5B%5D=64&multi_equipe_select%5B%5D=70&multi_equipe_select%5B%5D=67&multi_equipe_select%5B%5D=68&multi_equipe_select%5B%5D=66&multi_equipe_select%5B%5D=65&multi_equipe_select%5B%5D=74&multi_equipe_select%5B%5D=75&multi_equipe_select%5B%5D=72&multi_equipe_select%5B%5D=73&multi_equipe_select%5B%5D=48&multi_equipe_select%5B%5D=54&multi_equipe_select%5B%5D=49&multi_equipe_select%5B%5D=55&multi_equipe_select%5B%5D=57&multi_equipe_select%5B%5D=56&multi_equipe_select%5B%5D=58&multi_equipe_select%5B%5D=62&multi_equipe_select%5B%5D=61&multi_equipe_select%5B%5D=52&multi_equipe_select%5B%5D=60&multi_equipe_select%5B%5D=53&multi_equipe_select%5B%5D=50&multi_equipe_select%5B%5D=59&multi_equipe_select%5B%5D=63&multi_equipe_select%5B%5D=51&multi_equipe_select%5B%5D=47&multi_equipe_select%5B%5D=42&multi_equipe_select%5B%5D=43&multi_equipe_select%5B%5D=46&multi_equipe_select%5B%5D=45&multi_equipe_select%5B%5D=44
          @start_date = report.start_date
          @end_date = report.end_date
          params[:end_date_eval[0]] = @end_date
          params[:start_date_eval[0]] = @start_date
          params[:type] = report.report_type
          #params[:bp_select] = task.bp_select
          #params[:sex_select] = task.sex_select
          #params[:sport_select] = task.sport_select
          #params[:tb_select] = task.tb_select
          params[:eval_test_id] = report.eval_test_id
          params[:end_date_rapport[0]] = @end_date
          params[:start_date_rapport[0]] = @start_date
          params[:evaluation] = report.evaluation
          if is_user_in_role?(@user, 'DIR')
            collect_director_stats
          end
          if is_user_in_any_role?(@user, ['TRAINER', 'PHYSIO'])
            collect_trainer_stats
          end
          WickedPdf.config = {
          exe_path: "#{Rails.root}/bin/wkhtmltopdf-amd64"
        }
          pdf = WickedPdf.new.pdf_from_string(render_to_string(:action => :send_report,
           :layout => "report_layout.html.erb",
           :disable_smart_shrinking => false
           ))#,javascript_delay: 1000 required Version WickedPDF >= 10

          send_data(pdf,
          :filename => "report.pdf",
          :disposition => 'attachment',
          :encoding => 'utf8') 
          Organization.current_organization = saveOrg
        else
          redirect_to @current_user
        end
      else
          redirect_to @current_user
      end
    else
      redirect_to @current_user
    end
  end

  def add_report_task(type, parameters)    
      reportTask = ReportTask.new
      reportTask.report_type = type
      reportTask.frequency = parameters[:frequency]
      reportTask.user_id = @current_user.id
      reportTask.last_date = Date.today
      reportTask.organization_id = @current_organization.id
      
      if(type == 0) #Blessure
        if(parameters.include?(:equipe_select))
          if(parameters[:equipe_select].is_a? Array)
            equipe_select = parameters[:equipe_select].join(",")
          else
            equipe_select = parameters[:equipe_select]
          end
        else
          equipe_select = "0"
        end
        reportTask.equipe_select = equipe_select
        
        otherTask = ReportTask.where(:user_id => @current_user.id,
     :organization_id => @current_organization.id,
     :report_type => type,
     :frequency => parameters[:frequency],
     :equipe_select => equipe_select,
     :deleted=>0).first
      else #Evaluation
        reportTask.eval_test_id = parameters[:eval_test_id]

        if(parameters.include?(:multi_equipe_select))
          if(parameters[:multi_equipe_select].is_a? Array)
            equipe_select = parameters[:multi_equipe_select].join(",")
          else
            equipe_select = parameters[:multi_equipe_select]
          end
        end
        reportTask.equipe_select = equipe_select
        if(parameters.include?(:evaluation))
          if(parameters[:evaluation].is_a? Array)
            evaluation = parameters[:evaluation].join(",")
          else
            evaluation = parameters[:evaluation]
          end
        end
        reportTask.evaluation = evaluation
        otherTask = ReportTask.where(:user_id => @current_user.id,
     :organization_id => @current_organization.id,
     :report_type => type,
     :frequency => parameters[:frequency],
     :equipe_select => equipe_select,
     :evaluation => evaluation,
     :deleted=>0).first
      end


    if(otherTask.nil?)
      reportTask.save
    end
  end
#SECTION AJAX !
  def ajax_info_physique_edit
  @user = User.find(params[:id])
  info_physique
  update_anthropometrics
  update_age
  if @user.save
    if current_user?(@user)
      sign_in @user
    end
  end
  end

  def ajax_info_general_edit
    @user = User.find(params[:id])
  @user.update_attributes(ajax_general_user_params)

  process_emails @user, params[:user][:user_emails_attributes]
  process_phones @user, params[:user][:user_phones_attributes]
  @user = User.find(params[:id])
  if @user.save
    if current_user?(@user)
      sign_in @user
    end
  end
  end

  def ajax_info_physique
    @user = User.find(params[:id])
  info_physique
  if !@user.hasAnthropometrics?
     new_phone_email_anthro_membership
  end
  end

  def ajax_info_general
    @user = User.find(params[:id])
    if !@user.has_address? or !@user.has_phones?
      new_phone_email_anthro_membership
    end
  end

  def ajax_result_team
     @user = User.find(params[:id])
    #@participe_equipes = @user.equipes
    if !params[:teamid].blank?
      team_panel_info(params[:teamid])
    else
      team_panel_info("0")
    end
  end

  def ajax_result_eval
    @update = false
    if(params[:commit] == "Ajouter")
      add_report_task(1, params)
    else
      @update = true
    end
    @user = User.find(params[:id])
    @participe_equipes = @user.equipes
    @admin_equipes = Equipe.where(:user_id => @user.id)
    if is_user_in_role?(@user, 'DIR')
      collect_director_stats
    end
    if is_user_in_any_role?(@user, ['TRAINER', 'PHYSIO'])
      collect_trainer_stats
    end
  end

  def ajax_result_blessure
    @update = false
    if(params[:commit] == "Ajouter")
      add_report_task(0, params)
    else
      @update = true      
    end
    @user = User.find(params[:id])
    @participe_equipes = @user.equipes
    @admin_equipes = Equipe.where(:user_id => @user.id)
    if is_user_in_role?(@user, 'DIR')
      collect_director_stats
    end
    if is_user_in_any_role?(@user, ['TRAINER', 'PHYSIO'])
      collect_trainer_stats
    end
  end

  def ajax_cancel
  @user = User.find(params[:id])
  end

  def ajax_update_photo
    @user = User.find(params[:id])
    @user.update_attributes(user_params.permit(:photo))
    if @user.save
      if current_user?(@user)
        sign_in @user
      end
    end
    redirect_to @user
  end

#END SECTION AJAX !


private
  def user_params
    params.require(:user).permit(:last_name, :first_name, :email, :password, :password_confirmation,
                                 :role_id, :organization_id, :registration_token, :is_enabled,
                                 :user_phones, :multi_equipe_select,
                                 :address, :city, :state, :postalCode, :country, :photo, :banner,
                                 :sex, :change_password_required,
                                 user_phone_attributes: [:type, :number])
  end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def ajax_general_user_params
    params.require(:user).permit(:address, :city, :state, :postalCode, :country, :email, :registration_token)
  end

end
