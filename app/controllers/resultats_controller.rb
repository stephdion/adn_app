class ResultatsController < ApplicationController

  def new_team
      @resultat = Resultat.new
  end

  def new_athlete
      @resultat = Resultat.new
  end

  def index
    equipes = Array.new
    if @current_role.code == ("SYSADM" || "DIR") || @adn_sysadmin
      equipes = Equipe.in_organization
    else
      equipes = @current_user.equipes | Equipe.where(:user_id => current_user.id)
    end

    athletes = Array.new
    athletes = User.in_organization(["ATHLETE"])

    @resultats_equipe = Resultat.index_equipe(equipes.map(&:id))

    @resultats_individual = Resultat.index_individual(athletes.map(&:id))

    @current_user_participations = current_user.equipes
  end

  def index_detail
    @first_record = Resultat.find(params[:resultat_id])
    timestamp = @first_record.created_at
    eval_id = @first_record.evaluation_id
    evaluator = @first_record.user_id
    equipe_id = @first_record.equipe_id
    @resultats = Resultat.index_detail(eval_id, evaluator, equipe_id, timestamp)
    if @first_record.evaluation
      evaluation = Evaluation.find(eval_id)
      @maximum_score = evaluation.maximum_score
      @total_score = 0
      @total_athletes = 0
      @resultats.each do |resultat|
      if resultat.score.to_i <= @maximum_score
          @total_score += resultat.score.to_i
        @total_athletes += 1
        end
      end
    else
      @maximum_score = 0
      @total_score = 0
      @total_athletes = 0
    end
  end

  def athlete
    @first_record = Resultat.find(params[:resultat_id])
    timestamp = @first_record.created_at
    eval_id = @first_record.evaluation_id
    athlete_id = @first_record.athlete_id
    evaluator = @first_record.user_id
    @resultats = Resultat.get_evaluation_results(eval_id, evaluator,
                                                athlete_id, nil, timestamp,
                                                1.minute, "test_order")

    if @first_record.evaluation
      @maximum_score = @first_record.evaluation.maximum_score
    else
      @maximum_score = 0
    end

    @score = 0

    if !@first_record.evaluation.any_exercises?
      @resultats.each do |resultat|
        if resultat.component == 1
          @score += resultat.value
          if resultat.left_right?
            @score += resultat.left_side
          end
        end
      end
      render 'athlete_no_exercises'
      return

    else
      @labels = Array.new
      @chart_data = Array.new
      @resultats.each do |resultat|
        if resultat.component == 1
          @chart_data << resultat.value
          @score += resultat.value
          if resultat.left_side != 100
            @labels << resultat.eval_test.short_name.to_s + "-D"
            @labels << resultat.eval_test.short_name.to_s + "-G"
            @chart_data << resultat.left_side
            if !resultat.left_side.nil?
              @score += resultat.left_side
            end
          else
            @labels << resultat.eval_test.short_name.to_s
          end
        end
      end
    end

    # is there an earlier evaluation in the database?
    earlier_id = get_earlier_eval_resultat_id(eval_id, athlete_id, timestamp)
    @score2 = 0
    @chart_data2 = Array.new

    if earlier_id
      @earlier_first_record = Resultat.find(earlier_id)
      earlier_timestamp = @earlier_first_record.created_at
      earlier_eval_id = @earlier_first_record.evaluation_id
      earlier_athlete_id = @earlier_first_record.athlete_id
      earlier_evaluator = @earlier_first_record.user_id
      @earlier_resultats = Resultat.get_evaluation_results(earlier_eval_id, earlier_evaluator,
                                                earlier_athlete_id, nil, earlier_timestamp,
                                                1.minute, "test_order")

      @earlier_resultats.each do |earlier_resultat|
        if earlier_resultat.component == 1
          @chart_data2 << earlier_resultat.value
          @score2 += earlier_resultat.value
          if earlier_resultat.left_side != 100
            @chart_data2 << earlier_resultat.left_side
            @score2 += earlier_resultat.left_side
          end
        end
      end

    else
      @chart_data2 = [0]
    end

      render 'athlete'
    end

  def programme_corrective
    @first_record = Resultat.find(params[:resultat_id])
    timestamp = @first_record.created_at
    eval_id = @first_record.evaluation_id
    athlete_id = @first_record.athlete_id
    evaluator = @first_record.user_id
    @resultats = Resultat.get_evaluation_results(eval_id, evaluator, athlete_id, nil, timestamp, 1.minute, "exercise_order")
    evaluation = Evaluation.find(eval_id)
    @maximum_score = evaluation.maximum_score
    @score = 0
    @resultats.each do |resultat|
      if resultat.component == 1
        @score += resultat.value
        if !resultat.left_side.nil? &&resultat.left_side != 100
          @score += resultat.left_side
        end
      end
    end
    respond_to do |format|
      format.html
      format.pdf do
        render :pdf => "solution_corrective",
               :template => 'resultats/SolutionPDF.html.erb',
               :encoding => 'utf8',
               :page_size  => "Letter",
               :dpi => '600',
               :zoom => 0.7,
               :disable_smart_shrinking => false
      end
    end
  end


  def show
    @resultat = Resultat.find(params[:id])
  end

  def edit
    @resultat = Resultat.find(params[:id])
  end

  def update
    @resultat = Resultat.find(params[:id])
    if @resultat.update_attributes(params[:resultat])
      flash[:success] = "Resultat modifier"
      redirect_to @resultat
    else
      render 'edit'
    end
  end

  def create
    session[:evaluation_id] = (params[:resultat][:evaluation_id])
    session[:equipe_id] = (params[:resultat][:equipe_id])
    session[:athlete_id] = (params[:resultat][:athlete_id])
    session[:user_id] = current_user.id
    @current_eval_test = get_first_test
    @eval_tests = get_tests
    if session[:equipe_id] == nil
    duplicate_evaluation = Resultat.get_evaluation_results(session[:evaluation_id], session[:user_id], session[:athlete_id], nil, Time.now, 12.hours, "test_order")
    else
    duplicate_evaluation = Resultat.get_evaluation_results(session[:evaluation_id], session[:user_id], nil, session[:equipe_id], Time.now, 12.hours, "test_order")

    end
    if duplicate_evaluation.any?
      session[:creation_time] = duplicate_evaluation.first.created_at
      flash.now[:alert] = I18n.t(:resultats_duplicate_eval)
    else
      if !create_test_resultats(@eval_tests)
        flash.now[:alert] = "Echec"
      end
    end
    @resultats = get_resultats(@current_eval_test.id)
    @resultat_data = Resultat.new
    @resultat_data.user_id = session[:user_id]
    @resultat_data.created_at = session[:creation_time]
    render 'prise_de_donnees'
  end

  def prise_donnees
    if params[:next_test] == I18n.t(:resultats_eval_finished) #user select eval finfished?
        @resultats_with_errors = Resultat.update(params[:resultats].keys, params[:resultats].values).reject { |p| p.errors.empty? }
        @resultat_data = Resultat.new
        @resultat_data.created_at_string= (params[:resultat][:created_at_string])
        @resultat_data.user_id = params[:resultat][:user_id]
      if !@resultat_data.valid? #check if data is valid
        @current_eval_test = EvalTest.where(:short_name => params[:current_eval_test_short_name]).first
        @eval_tests = get_tests
        @resultats = get_resultats(@current_eval_test.id)
        render 'prise_de_donnees' #re-render form if there are errors
      else
        if @resultat_data.created_at_string != session[:creation_time].strftime("%Y-%m-%d %H:%M")
            Resultat.resultat_records_for_update(session[:creation_time], session[:user_id], session[:athlete_id], session[:equipe_id]).update_all(:created_at => @resultat_data.created_at)
            session[:creation_time] = @resultat_data.created_at
        end
        if (params[:resultat][:user_id] != session[:user_id])
            Resultat.resultat_records_for_update(session[:creation_time], session[:user_id], session[:athlete_id], session[:equipe_id]).update_all(:user_id => @resultat_data.user_id)
            session[:user_id] = params[:resultat][:user_id]
        end
        flash.now[:notice] = "Resultats de l'évaluation enregistré avec succès!"
        @resultats_final = get_all_resultats
        @first_record = @resultats_final.first
        render 'evaluation_complete'
      end
    else
      @resultat = Resultat.update(params[:resultats].keys, params[:resultats].values).reject { |p| p.errors.empty? }
      flash.now[:notice] = "Resultats de l'évaluation enregistré avec succès!"
      @current_eval_test = EvalTest.where(:short_name => params[:next_test]).first
      @eval_tests = get_tests
      @resultats = get_resultats(@current_eval_test.id)
      @resultat_data = Resultat.new
      @resultat_data.user_id = params[:resultat][:user_id]
      @resultat_data.created_at_string=(params[:resultat][:created_at_string])
      render 'prise_de_donnees'
    end
  end

  def restart_evaluation
    @first_record = Resultat.find(params[:resultat_id])
    session[:evaluation_id] = @first_record.evaluation_id
    session[:equipe_id] = @first_record.equipe_id
    session[:athlete_id] = @first_record.athlete_id
    session[:creation_time] = @first_record.created_at
    session[:user_id] = @first_record.user_id
    @current_eval_test = get_first_test
    @eval_tests = get_tests
    @resultats = get_resultats(@current_eval_test.id)
    @resultat_data = Resultat.new
    @resultat_data.user_id = session[:user_id]
    @resultat_data.created_at = session[:creation_time]
    render 'prise_de_donnees'
  end

  def confirm_delete
    @first_record = Resultat.find(params[:resultat_id])
    @target = (params[:delete_target])
    @resultats = get_resultats_to_delete(@first_record, @target)
  end

  def destroy
    @first_record = Resultat.find(params[:id])
    @target = (params[:delete_target])
    @resultats = get_resultats_to_delete(@first_record, @target)
    @resultats.each do |resultat|
      Resultat.destroy(resultat.id)
    end
    flash[:success] = t(:resultats_deleted)
    redirect_to resultats_url
  end

  private

  def correct_user_for_resultat
      resultat = Resultat.find(params[:id])
      user = User.find(resultat.user.id)
      redirect_to(root_path) unless current_user?(user)
  end

  def get_athletes
    if !(session[:equipe_id])
      return User.where(:id => session[:athlete_id])
    else
      return Equipe.find(session[:equipe_id]).get_members(Role.athlete_role)
    end
  end


  def create_test_resultats(tests)
    resultats = Array.new
    athletes = get_athletes
    first_record_indicator = true
    if tests != nil
       tests.each do |test|
        athletes.each do |athlete|
          resultat = current_user.resultats.build(:athlete_id => athlete.id,
                                                  :evaluation_id => session[:evaluation_id],
                                                  :equipe_id => session[:equipe_id],
                                                  :eval_test_id => test.id) if signed_in?
          resultat.init_values(test)
          resultat.save
          if first_record_indicator
              session[:creation_time] = resultat.created_at
              first_record_indicator = false
          end
        end
      end
      return true
    else
      return false
    end
  end

  def get_first_test
   all_eval_tests = Array.new
   all_eval_tests = Evaluation.find(session[:evaluation_id]).eval_tests
   return all_eval_tests.first
  end

  def get_tests
   all_eval_tests = Array.new
   evaluation = Evaluation.find(session[:evaluation_id])
   evaluation.test_sets.each do |test_set|
    if test_set.eval_test
      all_eval_tests << test_set.eval_test
    end
   end
   return all_eval_tests
  end

  def get_resultats(test_id)
    resultats = Array.new
      if session[:equipe_id] == nil
        resultats = Resultat.where(:created_at => (session[:creation_time] - 1.minute)..(session[:creation_time] + 1.minute)).
                              where(:user_id => session[:user_id],
                                    :eval_test_id => test_id,
                                    :athlete_id => session[:athlete_id])
         if resultats.blank?
        resultats = Resultat.new(:user_id => session[:user_id],
        :created_at => session[:creation_time],
        :updated_at => session[:creation_time],
        :eval_test_id => test_id,
        :athlete_id => session[:athlete_id],
        :evaluation_id => session[:evaluation_id],
        :value => 99,
        :component => 1,
        :left_value => 100).save
        resultats = Resultat.where(:created_at => (session[:creation_time] - 1.minute)..(session[:creation_time] + 1.minute)).
        where(:user_id => session[:user_id],
        :eval_test_id => test_id,
        :equipe_id => session[:equipe_id]).
        order("athlete_id")
        end
      else
        resultats = Resultat.where(:created_at => (session[:creation_time] - 1.minute)..(session[:creation_time] + 1.minute)).
                              where(:user_id => session[:user_id],
                                    :eval_test_id => test_id,
                                    :equipe_id => session[:equipe_id]).
                              order("athlete_id")
        if resultats.blank?
        Resultat.new(:user_id => session[:user_id],
        :created_at => session[:creation_time],
        :updated_at => session[:creation_time],
        :eval_test_id => test_id,
        :equipe_id => session[:equipe_id],
        :evaluation_id => session[:evaluation_id],
        :value => 99,
        :component => 1).save
        resultats = Resultat.where(:created_at => (session[:creation_time] - 1.minute)..(session[:creation_time] + 1.minute)).
        where(:user_id => session[:user_id],
        :eval_test_id => test_id,
        :equipe_id => session[:equipe_id]).
        order("athlete_id")
        end
      end

    return resultats
  end

  def get_all_resultats
    resultats_all = Array.new
    if session[:equipe_id] == nil
            resultats_all = Resultat.joins('INNER JOIN test_sets ON resultats.eval_test_id = test_sets.eval_test_id AND resultats.evaluation_id = test_sets.evaluation_id').
                                     where(:created_at => (session[:creation_time] - 1.minute)..(session[:creation_time] + 1.minute)).
                                     where(:user_id => session[:user_id],
                                           :athlete_id => session[:athlete_id]).
                                     order("test_sets.test_order ASC")
            else
            resultats_all = Resultat.joins('INNER JOIN test_sets ON resultats.eval_test_id = test_sets.eval_test_id AND resultats.evaluation_id = test_sets.evaluation_id').
                                     where(:created_at => (session[:creation_time] - 1.minute)..(session[:creation_time] + 1.minute)).
                                     where(:user_id => session[:user_id],
                                           :equipe_id => session[:equipe_id]).
                                     order("test_sets.test_order ASC")
    end
    return resultats_all
  end

  def result_values_OK?
    return_value = true
    if !@resultat.empty?
      return_value = false
    end
    params[:resultats].values.each do |resultat|
      if resultat[:value] == '99'
         return_value = false
      end
    end
    return return_value
  end

  def get_resultats_to_delete(resultat, target)
    timestamp = resultat.created_at
    eval_id = resultat.evaluation_id
    evaluator = resultat.user_id
    if target == "team"
      equipe_id = resultat.equipe_id
      resultats = Resultat.where(:evaluation_id => eval_id,
                                  :user_id => evaluator,
                                  :equipe_id => equipe_id,
                                  :created_at => (timestamp - 1.minute)..(timestamp + 1.minute)).
                          select("athlete_id, equipe_id, date(created_at) as eval_day, eval_test_id, value, left_side, user_id, id").
                          order("created_at ASC")

    elsif target == "athlete"
      athlete_id = resultat.athlete_id
      resultats = Resultat.where(:evaluation_id => eval_id,
                                  :user_id => evaluator,
                                  :athlete_id => athlete_id,
                                  :created_at => (timestamp - 1.minute)..(timestamp + 1.minute)).
                          select("resultatid, equipe_id, date(created_at) as eval_day, eval_test_id, value, left_side, user_id, id").
                          order("created_at ASC")
    else
      resultats = []
    end
    return resultats
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

