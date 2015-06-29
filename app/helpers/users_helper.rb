module UsersHelper

  def validate_string(value)
    return value && !value.empty? ? value : nil;
  end

  def new_phone_email_anthro_membership
    1.times { @user.user_phones         .build }
    1.times { @user.user_emails         .build }
    1.times { @user.memberships         .build }
    1.times { @user.family_members      .build }

    if !@user.hasAnthropometrics?
      1.times { @user.user_anthropometrics.build }
    end
  end
  
  def update_anthropometrics
  params[:user][:user_anthropometrics_attributes].values.each do |anthropometry|

      if anthropometry[:id].blank?
        if !anthropometry[:weight].blank? || !anthropometry[:height].blank?
          @user.user_anthropometrics.push(UserAnthropometric.new(anthropometry.slice!(:id)))
        end
      else
        UserAnthropometric.find(anthropometry[:id]).update_attributes(anthropometry.slice!(:id))
      end
    end
  end
  
  def update_age
    year = params[:user]['birthday(1i)'].to_i
    month = params[:user]['birthday(2i)'].to_i
    day = params[:user]['birthday(3i)'].to_i
    if year!=0 && month!=0 && day !=0
      @user.birthday = Date.civil(params[:user]['birthday(1i)'].to_i,
                                  params[:user]['birthday(2i)'].to_i,
                                  params[:user]['birthday(3i)'].to_i)
    end
  end
  
  def process_phones (user, phones)
    clear_phones @user
    if phones
      phones.values.each do |phones|
        if phones[:_destroy] == '1' && !phones[:id].blank?
          UserPhone.find(phones[:id]).destroy
        elsif phones[:id].blank?
          if !phones[:phone_type].blank? && !phones[:number].blank?
            user.user_phones.push(UserPhone.new(phones.slice!(:id,:_destroy)))
          end
        else
          UserPhone.find(phones[:id]).update_attributes(phones.slice!(:id,:_destroy))
        end
      end
    end
  end

  def clear_phones (user)
    user.user_phones.each do |phone|
      if !phone[:number]
        user.user_phones.delete_at(user.user_phones.index(phone))
      end
    end
  end

  def process_emails (user, emails)
    clear_emails @user
    if emails
      emails.values.each do |emails|
        if emails[:_destroy] == '1' && !emails[:id].blank?
          UserEmail.find(emails[:id]).destroy
        elsif emails[:id].blank?
          if !emails[:email_type].blank? && !emails[:email].blank?
            @user.user_emails.push(UserEmail.new(emails.slice!(:id,:_destroy)))
          end
        else
          UserEmail.find(emails[:id]).update_attributes(emails.slice!(:id,:_destroy))
        end
      end
    end
  end

  def clear_emails (user)
    user.user_emails.each do |email|
      if !email[:email]
        user.user_emails.delete_at(user.user_emails.index(email))
      end
    end
  end

  def process_memberships (user, memberships)
    clear_memberships @user
    if memberships
      memberships.values.each do |membership|
        if membership[:_destroy] == '1' && !membership[:id].blank?
          Membership.find(membership[:id]).destroy
        elsif membership[:id].blank?
          if !membership[:organization_id].blank? && !membership[:role_id].blank?
            @user.memberships.push(Membership.new(membership.slice!(:id,:_destroy)))
          end
        else
          Membership.find(membership[:id]).update_attributes(membership.slice!(:id,:_destroy))
        end
      end
    end
  end

  def clear_memberships (user)
    user.memberships.each do |membership|
      if !membership[:organization_id] && !membership[:role_id]
        user.memberships.delete_at(user.memberships.index(membership))
      end
    end
  end

  def process_family_members (user, family_members)
    clear_family_members @user
    if family_members
      family_members.values.each do |parent|
        if parent[:_destroy] == '1' && !parent[:id].blank?
          FamilyMember.find(parent[:id]).destroy
        elsif parent[:id].blank?
          if !parent[:relationship].blank? && !parent[:parent_id].blank?
            @user.family_members.push(FamilyMember.new(parent.slice!(:id,:_destroy)))
          end
        else
          FamilyMember.find(parent[:id]).update_attributes(parent.slice!(:id,:_destroy))
        end
      end
    end
  end

  def clear_family_members (user)
    user.family_members.each do |parent|
      if !parent[:parent_id] && !parent[:relationship]
        user.family_members.delete_at(user.family_member.index(parent))
      end
    end
  end

  def team_panel_info (value)
    @participe_equipes = @user.equipes
    @admin_equipes = Equipe.where(:user_id => @user.id)
    if !value.blank? && value != "0"
      @equipe = Equipe.find(value)#Equipe.where(:user_id => @user.id, :id => params[:teamid])
      @athletes = @equipe.get_members(Role.athlete_role)
      @trainers = @equipe.get_members(Role.trainer_role)
      @physios = @equipe.get_members(Role.physio_role)
      #@participants_info = Equipe.users_and_positions(value)
      @resultats_team = Resultat.where(:equipe_id => value).
                            select("date(created_at) as eval_day, 
                                    evaluation_id,
                                    min(user_id) as user_id, 
                                    min(id) as resultat_id,
                                    sum((value + left_side%100)*component) as score").
                            group("eval_day, evaluation_id").
                            order("eval_day ASC")
        @record_count = 0
        @resultats_team.each do |resultat|
          @record_count += 1
        end
      if is_user_in_any_role?(@user, ['TRAINER', 'PHYSIO'])
        collect_trainer_stats
      elsif is_user_in_role?(@user,'DIR')
        collect_director_stats
      end
        
    elsif !value.blank? && value == "0"
      #@equipeArray.push(:id => EvalType.find(eval.evaluation.eval_type_id).id, :name => EvalType.find(eval.evaluation.eval_type_id).name)

      if is_user_in_any_role?(@user, ['TRAINER', 'PHYSIO'])
        collect_trainer_stats
      elsif is_user_in_role?(@user,'DIR')
        collect_director_stats
      end
      @search_equipe = @all_teams #| @participe_equipes#Equipe.where(:user_id => @user.id)
    end
  end

    def get_earlier_eval_resultat_id(eval_id, athlete_id, timestamp)
    resultats = Resultat.where(:evaluation_id => eval_id, 
                               :athlete_id => athlete_id). 
                         where("created_at < ?", (timestamp - 24.hours)).
                         select("id, date(created_at) as eval_day").
                         order("eval_day DESC")
    if resultats.any?                     
      return resultats.first.id
    else
      return nil
    end

  end
  
end