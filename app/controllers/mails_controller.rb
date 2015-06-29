class MailsController < ApplicationController
  include EmailHelper

  def destroy
    mail = MailUser.find(params[:id])
    mail.deleted = 1
    mail.save
    redirect_to :action => 'index'
  end

  def index
    if(params[:status] == "0")
      @mails = MailUser.where(:uid_to => @current_user.id, :deleted => false).page(params[:page]).order('date_created desc')
    else
      @mails = MailUser.where(:uid_from => @current_user.id, :deleted => false).page(params[:page]).order('date_created desc')
    end
  end

  def new

    @mail = MailUser.new
    @users_to = Array.new
    @added = Array.new
    @userList = Array.new
    @mail_method = 0 #0 = single mail, 1 = change select for span, 2 = multiple mail
    #AWS.config(:access_key_id    => ENV['AWS_ACCESS_KEY_ID'],
     #         :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY'] )

    #@S3_BUCKET = AWS::S3.new.buckets[ENV['S3_BUCKET_NAME']]
    @htmlUser = ""
    if( is_current_user_adn_sysadmin? )
        @teams = Equipe.all()

    elsif(is_user_in_any_role?(@current_user, ['DIR', 'ADMIN']) )
        @teams = @current_organization.equipes
    else
        @teams = @current_user.equipes#Participation.where(:user_id=>@user, :archived=>nil)
    end

      #@users_to = @current_user.trainers
      #@users_to += @current_user.physios
    if params[:id]
      @mail_method = 1
      @users_to.push(params[:id].to_i)
    elsif params[:arr]
      @mail_method = 2
      arr = params[:arr]
      arr.each do |user|
          @users_to.push(user.to_i)
      end
    else
      @mail_method = 0
    end

      if(is_user_in_any_role?(@current_user, ['SYSADM']) || is_current_user_sysadmin? )
        orgList = Organization.all
        @htmlUser << "<optgroup label='Directeurs'>"
        orgList.each do |org|
          dir = Membership.where("organization_id = ? AND role_id = 5", org.id)
          if(!dir.nil? && !dir.empty?)
            if(dir.kind_of?(Array))
              dir.each do |d|
                @htmlUser << "<option value='#{d.user_id}'>#{d.user.name} [#{org.name}]</option>"
              end
            else
              @htmlUser << "<option value='#{dir[0].user_id}'>#{dir[0].user.name} [#{org.name}]</option>"
            end
          end
          
        end
        @htmlUser << "</optgroup>"
      elsif (is_user_in_any_role?(@current_user, ['TRAINER', 'PHYSIO']) || is_current_user_sysadmin?)
        org = @current_organization
        @htmlUser << "<optgroup label='Directeurs'>"
          dir = Membership.where("organization_id = ? AND role_id = 5", org.id)
          if(!dir.nil? && !dir.empty?)
              @htmlUser << "<option value='#{dir[0].user_id}'>#{dir[0].user.name} [#{org.name}]</option>"
          end
        @htmlUser << "</optgroup>"
      end
      @teams.each do |team|
        if(is_user_in_any_role?(@current_user, ['TRAINER', 'PHYSIO', 'DIR', 'ADMIN', 'SYSADM']) || is_current_user_sysadmin? )
          @userList.push(User.find(team.user_id))
          @userlist = Equipe.find(team.id).get_members(Role.trainer_role) + Equipe.find(team.id).get_members(Role.physio_role) + Equipe.find(team.id).get_members(Role.athlete_role)
        else
          @userList.push(User.find(team.user_id))
          @userlist = Equipe.find(team.id).get_members(Role.trainer_role) + Equipe.find(team.id).get_members(Role.physio_role)
        end
        #@userlist.sort_by!{|e| e[:first_name]}
        @htmlUser << "<optgroup label='"+team.name+"'>"
        
        @userlist.each do |user|
          if(user.id == @current_user.id)
            next
          end
          teamList = user.equipes
          role = ""
          if(teamList.include?(team))
            if(user.current_role.id != 9)
              role = user.current_role.name
            else
              #role = User.where(:deleted=>0).joins(:memberships).where("memberships.organization_id = ?", team.organization_id)
              role = Membership.where("organization_id = ? AND user_id = ?", team.organization_id, user.id)[0].getName
            end
          end
          if(@users_to.include?(user.id) && @added.exclude?(user.id))
            @added.push(user.id)
            @htmlUser << "<option value='"<<user.id.to_s<<"' selected='selected'>"<<user.name<< " [#{role}]"<<"</option>"
          else
            @htmlUser << "<option value='"<<user.id.to_s<<"'>"<<user.name<<" [#{role}]"<<"</option>"
          end
        end
      end

      
        

        @htmlUser << "</optgroup>"
    #@s3_direct_post = @S3_BUCKET.presigned_post(key: "uploads/#{SecureRandom.uuid}/${filename}", success_action_status: 201, acl: :public_read)
@programmes = Programme.order(:name)
    
  end

  def show
    @mail = MailUser.find(params[:id])
    if @mail.uid_to != @current_user.id && @mail.uid_from != @current_user.id
      redirect_to :action => 'index'
    end
    
      @file_ok = false;
      if !@mail.file_hash.nil? && File.exist?(Rails.root.join('uploads', @mail.file_hash))
        @file_ok = true;
      end

      @programme_ok = false;
      if(!@mail.program.nil? && @mail.program != 0)
       @programme_ok = true;
       @programme = Programme.find(@mail.program)
      end

    if @mail.uid_to == @current_user.id
      @mail.read = true
    end

    @mail.save
  end

  def download
    if(params.include?(:hash))
      mail = MailUser.where("file_hash = ? AND (uid_to = ? OR uid_from = ?)",params[:hash], @current_user.id, @current_user.id).first
      if(!mail.nil? && (mail.uid_to == @current_user.id || mail.uid_from == @current_user.id))
        send_file(Rails.root.join('uploads', params[:hash]), :filename => mail.file_name)
      else
        abort("")
      end
    else
      abort("")
    end    
  end

  def create    
    #s.slice!(0)
    #if params[:uid_to].kind_of?(Array)
     # params[:uid_to].each do |uid|
      #  mail = MailUser.new
       # mail.uid_from = @current_user.id
        #mail.uid_to = uid
        #mail.message = params[:message][:message]
        #mail.subject = params[:subject]
        #mail.date_created = DateTime.now.strftime("%Y-%m-%d %H:%M:%S")
        
        #if mail.save
        #  msg = @@NEWMAIL_CONTENT % [User.find(uid).name, User.find(uid).email, @current_user.name, params[:subject], params[:message][:message]]
          #send_email(@current_user.email, msg)User.find(params[:uid_to]).email
        #  send_email("yan.boisjoly@fdcanada.ca", msg)
        #end
      #end
    #else
    sent = Array.new
    if(params.include?(:uid_to) && params[:uid_to] != "" && !params[:uid_to].nil? || params.include?(:all) && params[:all] != "" && !params[:all].nil?)
      if(params.include?(:file))
        uploaded_io = params[:file]
        hash = Digest::MD5.hexdigest(DateTime.now.strftime("%Y-%m-%d %H:%M:%S")+uploaded_io.original_filename)
        while(File::exists?( Rails.root.join('uploads',hash) )) do
          hash = Digest::MD5.hexdigest(DateTime.now.strftime("%Y-%m-%d %H:%M:%S")+uploaded_io.original_filename)
        end
        File.open(Rails.root.join('uploads',hash), 'wb') do |file|
          file.write(uploaded_io.read)
        end
      end


      @uidList = params[:uid_to]
      #@uidList.slice!(0)
      #@uidList = @uidList.split(",")
      #abort("")
      if @uidList.kind_of?(Array)
        @uidList.each do |uid|
          #if(!params[:file].nil?)
         #  mail = MailUser.new(params[:file])
          #else

            mail = MailUser.new
          #end
            mail.uid_from = @current_user.id
            mail.uid_to = uid.to_i
            mail.message = params[:message][:message]
            mail.subject = params[:subject]
            if(!params[:prog].nil? && params[:prog] != 0)
              mail.program = params[:prog]
            end
            if(!params[:linkyt].nil?)
              mail.linkyt = params[:linkyt]
            end
            if(!params[:file_program].nil?)
              mail.file_program = params[:file_program]
            end
            if(params.include?(:file))
              mail.file_name = uploaded_io.original_filename
              mail.file_hash = hash
            end
            
            mail.date_created = DateTime.now.strftime("%Y-%m-%d %H:%M:%S")
            if mail.save
              msg = @@NEWMAIL_CONTENT % [User.find(uid.to_i).name, User.find(uid.to_i).email, @current_user.name, params[:subject], params[:message][:message]]
              #send_email(User.find(uid).email, msg)
            end

        end
      else
          mail = MailUser.new
          mail.uid_from = @current_user.id
          mail.uid_to = @uidList
          mail.message = params[:message][:message]
          mail.subject = params[:subject]
          if(!params[:prog].nil? && params[:prog] != 0)
            mail.program = params[:prog]
          end
          if(!params[:linkyt].nil?)
            mail.linkyt = params[:linkyt]
          end
          if(!params[:file_program].nil?)
            mail.file_program = params[:file_program]
          end
            if(!params[:file].nil?)
             mail.file_name = uploaded_io.original_filename
             mail.file_hash = hash
            end
          mail.date_created = DateTime.now.strftime("%Y-%m-%d %H:%M:%S")
          if mail.save
            msg = @@NEWMAIL_CONTENT % [User.find(@uidList).name, User.find(@uidList).email, @current_user.name, params[:subject], params[:message][:message]]
            #send_email(@current_user.email, msg)User.find(params[:uid_to]).email
            #send_email(User.find(@uidList).email, msg)
          end
      end
      
    end
    redirect_to :action => 'index'
  end

  def ajax_prog
    @programmes = Programme.order(:name)
  end

  def ajax_team
    if(params.include?(:tid) && params[:tid] != "" && !params[:tid].nil?)
      #redirect_to :action => "index"
      if(is_user_in_any_role?(@current_user, ['TRAINER', 'PHYSIO', 'DIR', 'ADMIN', 'SYSADM']) || is_current_user_sysadmin? )
        @userlist = Equipe.find(params[:tid]).get_members(Role.trainer_role) + Equipe.find(params[:tid]).get_members(Role.athlete_role) + Equipe.find(params[:tid]).get_members(Role.physio_role)
      else
        @userlist = Equipe.find(params[:tid]).get_members(Role.trainer_role) + Equipe.find(params[:tid]).get_members(Role.physio_role)
      end
      @userlist.sort_by!{|e| e[:first_name]}
    #@athletes = @equipe.get_members(Role.athlete_role)
    #@trainers = @equipe.get_members(Role.trainer_role)
    #@physios = @equipe.get_members(Role.physio_role)
    end
  end
end