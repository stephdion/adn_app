module StatisticsHelper
    include AggregationHelper
    # If you change the first 3 colours - update css for year labels: .blessuresChart_year1...
    # year colors=[0-blue, 1-orange, 2-green, 3-lime, 4-red, 5-purple]
    @@chart_year_colors = ["#4884CB" ,"#4E5361","#006600", "#66FF33", "#8F0000", "#6600FF"]
    # pie colors=[0-red, 1-grey-blue, 2-orange, 3-green, 4-lime, 5-yellow, 6-aqua, 7-blue, 8-fire, 9-indigo, 10-purple, 11-burgandy, 12-grey, 13-gold, 14-black]
    @@pie_chart_colors = ["#4884CB","#4E5361","#FF6600","#006600","#66FF33","#B2B200", "#CC3300", "#0066CC", "#29527A", "#00005C", "#6600FF", "#663300", "#999966", "#A37A00", "#000000", "#8F0000","#3399FF","#FF6600","#006600","#66FF33","#B2B200", "#CC3300", "#0066CC", "#29527A", "#00005C", "#6600FF", "#663300", "#999966", "#A37A00", "#000000", "#8F0000","#3399FF","#FF6600","#006600","#66FF33","#B2B200", "#CC3300", "#0066CC", "#29527A", "#00005C", "#6600FF", "#663300", "#999966", "#A37A00", "#000000"]
    @@chart_month_labels = [I18n.t(:chart_month_labels_Jan), I18n.t(:chart_month_labels_Feb), I18n.t(:chart_month_labels_Mar),
                            I18n.t(:chart_month_labels_Apr), I18n.t(:chart_month_labels_May), I18n.t(:chart_month_labels_Jun),
                            I18n.t(:chart_month_labels_Jul), I18n.t(:chart_month_labels_Aug), I18n.t(:chart_month_labels_Sep),
                            I18n.t(:chart_month_labels_Oct), I18n.t(:chart_month_labels_Nov), I18n.t(:chart_month_labels_Dec)]

    def collect_director_stats()
        @program_participants = User.in_organization(["ALL"])
        @all_teams = Equipe.in_organization
        athletes = User.in_organization(["ATHLETE"])

        if @program_participants
            collect_org_user_stats(@program_participants)
        end
        if athletes
            collect_blessure_stats(athletes)
            collect_evaluation_stats(athletes)
        end
    end

    def collect_trainer_stats()
        @programme_participants = Array.new
        athletes = Array.new
        @all_teams = @admin_equipes | @user.equipes
        @programme_participants = User.includes(blessures: [:user, :equipe_type]).joins(:participations, :memberships).where("participations.equipe_id IN (?) AND participations.archived IS NULL AND memberships.organization_id = ?", @all_teams.to_a.map(&:id), @current_organization.id).distinct
        athletes = @programme_participants.where("memberships.role_id = ?", Role.athlete_role.id)

        if @programme_participants
            collect_org_user_stats(@programme_participants)
        end
        if athletes
            collect_blessure_stats(athletes)
            collect_evaluation_stats(athletes)
        end
    end

    def collect_org_user_stats(org_users)
        @athlete_count = 0
        @male_athletes = 0
        @female_athletes = 0
        @dir_admin = 0
        @resp_admin = 0
        @trainer_admin = 0
        adn_admin_ids = Membership.where(:organization_id => Organization.admin_organization).map(&:user_id)
        if org_users
            org_users.each do |user|
                if !adn_admin_ids.include?(user.id) #don't get stats for adn staff
                    if user.memberships.first.role.code == "ATHLETE" #found an athlete
                        @athlete_count += 1
                        if user.sex == I18n.t(:user_male)
                            @male_athletes += 1
                        elsif user.sex == I18n.t(:user_female)
                            @female_athletes += 1
                        end
                    else #found an admin (TRAINER, SYSADMN, DIR - don't count directors)
                        if user.memberships.first.role.code == "TRAINER"
                            if Equipe.where(:user_id => user.id) != []
                                @resp_admin += 1
                            else
                                @trainer_admin += 1
                            end
                        end
                    end
                end
            end
        end
    end

    def collect_evaluation_stats(all_athletes)
        # Get the criteria for the search
        if params[:resultat_start_date].blank? && params[:start_date_eval].blank?
            start_date = Time.now - 2.years
            params[:resultat_start_date] = start_date.strftime("%Y-%m-%d")
        else
            if !params[:start_date_eval].blank?
                date = params[:start_date_eval][0]
            else
                date = params[:resultat_start_date]
            end
            start_date = Date.strptime(date, "%Y-%m-%d")
        end
        params.delete :start_date_eval

        if params[:resultat_end_date].blank? && params[:end_date_eval].blank?
            end_date = Time.now
            params[:resultat_end_date] = end_date.strftime("%Y-%m-%d")
        else
            if !params[:end_date_eval].blank?
                date = params[:end_date_eval][0]
            else
                date = params[:resultat_end_date]
            end
            end_date = Date.strptime(date, "%Y-%m-%d")
        end
        params.delete :end_date_eval

        evals_id = get_evaluation_ids(params[:evaluation])

        if params[:low_score] == "0" || params[:low_score] == nil
            @low_score = 0
            params[:low_score] = 0
        else
            @low_score = params[:low_score].to_i
        end

        if params[:high_score] == "0" || params[:high_score] == nil
            @high_score = 100
            params[:high_score] = 100
        else
            @high_score = params[:high_score].to_i
        end

        if params[:low_diff] == "0" || params[:low_diff] == nil
            @low_differential = 0
            params[:low_diff] = 0
        else
            @low_differential = params[:low_diff].to_i
        end

        if params[:high_diff] == "0" || params[:high_diff] == nil
            @high_differential = 100
            params[:high_diff] = 100
        else
            @high_differential = params[:high_diff].to_i
        end

        if params[:multi_equipe_select] == "null" || params[:multi_equipe_select].nil? || params[:multi_equipe_select] == "0" || params[:multi_equipe_select][0] == "0"
            selected_teams = @all_teams
        else
            if params[:multi_equipe_select].is_a?(Array)
                selected_teams_params = params[:multi_equipe_select]
            else
                selected_teams_params = params[:multi_equipe_select].split(',')
            end
            selected_teams = Array.new
            selected_teams_params.each do |team_id|
                selected_teams << Equipe.find(team_id)
            end
        end

        if params[:special_case_value] == nil
            params[:special_case_value]= @special_case_value = 1
        else
            @special_case_value = params[:special_case_value].to_i
        end

        if params[:special_case_test] == "0" || params[:special_case_test] == nil
            #Valgus test is the default (#73)
            if EvalTest.exists?(113)
                params[:special_case_test]= @special_case_eval_test_id = 73
            else
                params[:special_case_test]= @special_case_eval_test_id = EvalTest.first.id
            end
        else
            @special_case_eval_test_id = params[:special_case_test].to_i
        end

        if params[:eval_test_id] != "" && params[:eval_test_id] != nil
            @eval_test_id = params[:eval_test_id].to_i
        end

        @team_averages = Array.new
        selected_team_athlete_ids = Array.new
        @team_results = Hash.new 
        @team_graph_results = Hash.new
        @team_graph_results_value = Hash.new
        @special_cases = Array.new
        @test_data = Array.new

        evals_id.each do |eval_id|
            @evaluation = Evaluation.find_by_id(eval_id)
            @max_score = @evaluation.maximum_score

            @evaluation.get_all_exercices.each do |exercice|
                @special_cases << exercice
            end

            #calculate avg score and avg differential for each team
            selected_teams.each do |team|
                team_athlete_ids = team.get_members(Role.athlete_role).map(&:id)
                selected_team_athlete_ids = selected_team_athlete_ids | team_athlete_ids

                if @eval_test_id.nil?
                    unless @team_results.nil?
                        @team_results[team.id] = Resultat.dashboard(team_athlete_ids, @evaluation.id, start_date, end_date).order("athlete_last_name ASC")
                        @team_graph_results[team.id] = Resultat.get_graph_stats_by_test(team_athlete_ids, @evaluation.id, start_date, end_date)
                    else
                        @team_results[team.id] += Resultat.dashboard(team_athlete_ids, @evaluation.id, start_date, end_date).order("athlete_last_name ASC")
                        @team_graph_results[team.id] += Resultat.get_graph_stats_by_test(team_athlete_ids, @evaluation.id, start_date, end_date)
                    end
                else
                    unless @team_results.nil?
                        @team_results[team.id] = Resultat.dashboard_by_eval_test(team_athlete_ids, @evaluation.id, @eval_test_id, start_date, end_date).order("athlete_last_name ASC")
                        @team_graph_results[team.id] = Resultat.get_graph_stats_by_eval_test(team_athlete_ids, @evaluation.id, @eval_test_id, start_date, end_date)
                    else
                        @team_results[team.id] +=  Resultat.dashboard_by_eval_test(team_athlete_ids, @evaluation.id, @eval_test_id, start_date, end_date).order("athlete_last_name ASC")
                        @team_graph_results[team.id] += Resultat.get_graph_stats_by_eval_test(team_athlete_ids, @evaluation.id, @eval_test_id, start_date, end_date)
                    end
                end

                count = 0
                total_score = 0
                total_differential = 0
                total_value = 0
                total_left = 0
                @team_results[team.id].each do |result|
                    if result.score.to_i <= @max_score
                        count += 1
                        total_score += result.score.to_i
                        total_differential += result.differential.to_i
                    end
                end

                data_value = Array.new
                data_left = Array.new 
                name_exercices = Array.new
                @team_graph_results[team.id].each do |result|
                    name_exercices << result.short_name
                    data_value << (result.nbr_value.to_f/count).to_f
                    data_left << (result.nbr_left.to_f/count).to_f
                end

                @test_data[team.id] = name_exercices

                @team_graph_results_value[team.id] = [{"fillColor":"#4E5361","strokeColor":"#4E5361","data":data_left}, {"fillColor":"#4884CB","strokeColor":"#4884CB","data":data_value}]

                #Handle case where there are no evaluations for a team (avoid NaN)
                if total_score != 0
                    avg_score = Float(total_score)/Float(count)
                else
                    avg_score = 0
                end
                if total_differential != 0
                    avg_differential = Float(total_differential)/Float(count)
                else
                    avg_differential = 0
                end
                @team_averages << { :id => team.id, :name => team.name, :avg_score => avg_score , :avg_differential => avg_differential }
            end
        end

        @team_averages = fuse_avg_for_same_team(@team_averages).sort_by{|e| e[:avg_score]}

        @resultats_threshold_score = Resultat.dashboard(selected_team_athlete_ids, @evaluation.id, start_date, end_date)
        .having("(sum((resultats.value + resultats.left_side%100)*resultats.component)) BETWEEN ? AND ?", @low_score, @high_score).order("score DESC")
        @resultats_threshold_differential = Resultat.dashboard(selected_team_athlete_ids, @evaluation.id, start_date, end_date)
        .having("sum(CASE
                 WHEN (resultats.value * resultats.left_side) = 0 THEN 0
                 WHEN (resultats.left_side%100) = 0 THEN 0
                 ELSE  abs(resultats.value-resultats.left_side)
                 END) BETWEEN ? AND ?", @low_differential, @high_differential).order("differential DESC")
        @resultats_injuries = Resultat.injuries(selected_team_athlete_ids, @evaluation.id, start_date, end_date)
        @resultats_special_cases = Resultat.special_cases(selected_team_athlete_ids, @special_case_eval_test_id, @special_case_value, start_date, end_date)
        @resultats_left_right = Resultat.left_right(selected_team_athlete_ids, @evaluation.id, start_date, end_date)
    end

    def format_date_blessure(date)
        months = ["Janvier", "Février", "Mars", "Avril", "Mai", "Juin", "Juillet", "Août",
                  "Septembre", "Octobre", "Novembre", "Décembre"]

        date_splitted = date.strftime("%F").split('-')
        day = date_splitted[0];
        month = months[date_splitted[1]]
        year = date_splitted[2]

        date = day + " " + month + " " + year
    end

    def get_evaluation_ids(ids_param)
        if ids_param == "null"
            ids_param = evals_id = [2];
        else
            if ids_param == 0 || ids_param == nil
                #default evaluation is Functional evaluation (id=2)
                ids_param = evals_id = [2];
            else
                if ids_param.is_a?(Array)
                    evals_id = ids_param
                else
                    evals_id = ids_param.split(',')
                end
            end
        end

        return evals_id
    end

    def fuse_avg_for_same_team(teams_avg)
        new_team_avg = Array.new
        team_id_already_filter = Array.new

        teams_avg.each do |team|
            if !team_id_already_filter.include? team[:id]
                same_team_data = Array.new
                teams_avg.each do |team_search|
                    if team[:id] == team_search[:id]
                        same_team_data << team_search
                    end
                end

                nbr_same_team = same_team_data.count
                total_avg_score = 0
                total_avg_differential = 0

                same_team_data.each do |team_data|
                    total_avg_score += team_data[:avg_score]
                    total_avg_differential += team_data[:avg_differential]
                end

                total_avg_score = total_avg_score / nbr_same_team
                total_avg_differential = total_avg_differential / nbr_same_team

                new_team_avg << { :id => team[:id], :name => team[:name], :avg_score => total_avg_score , :avg_differential => total_avg_differential }

                team_id_already_filter << team[:id]
            end
        end

        return new_team_avg
    end

    def collect_blessure_stats(org_users)
        # Get the criteria for the search
        if params[:start_date].blank? && params[:start_date_rapport].blank?
            start_date = Time.now - 2.years
            params[:start_date] = start_date.strftime("%Y-%m-%d")
        else
            if params[:start_date].blank?
                date = params[:start_date_rapport][0]
            else
                date = params[:start_date]
            end
            start_date = Date.strptime(date, "%Y-%m-%d")
        end
        params.delete :start_date_rapport

        if params[:end_date].blank? && params[:end_date_rapport].blank?
            end_date = Time.now
            params[:end_date] = end_date.strftime("%Y-%m-%d")
        else
            if params[:end_date].blank?
                date = params[:end_date_rapport][0]
            else
                date = params[:end_date]
            end
            end_date = Date.strptime(date, "%Y-%m-%d")
        end
        params.delete :end_date_rapport

        if params[:sport_select] == "0" || params[:sport_select] == nil
            sport = nil
        else
            sport = params[:sport_select].to_i
        end

        if params[:bp_select] == I18n.t(:general_all) || params[:bp_select] == nil
            body_part = nil
        else
            body_part = params[:bp_select]
        end

        if params[:tb_select] == I18n.t(:general_all) || params[:tb_select] == nil
            type_de_blessure = nil
        else
            type_de_blessure = params[:tb_select]
        end

        if params[:sex_select] == I18n.t(:general_all) || params[:sex_select] == nil
            sex = nil
        else
            sex = params[:sex_select].to_s
        end

        if !(params[:equipe_select] == "0" || params[:equipe_select].nil? || params[:equipe_select][0] == "0")
            org_users = Participation.equipe_participants(params[:equipe_select])
        else
            org_users = org_users.pluck(:id)
        end

        @blessures = Blessure.dashboard(org_users, start_date, end_date, sport, body_part, sex, type_de_blessure)
        date = Hash.new { |hash, key| hash[key] = {} }
        sports = Hash.new
        types = Hash.new
        equipes = Hash.new
        sex = Hash.new
        positions = Hash.new
        year_in_team_since_wound = Hash.new
        blessures_by_member_type = Hash.new
        @year_colors = @@chart_year_colors
        @pie_colors = @@pie_chart_colors

        @blessures.each do |blessure| #gather data from blessure records
            #puts blessure[:id].to_s
            blessures_by_member_type = increment_on_key(blessures_by_member_type, blessure.bodypart.name)
            sex = increment_on_key(sex, blessure.user.sex)

            if (blessure.user.memberships.first.year_since_join != nil)
                year_in_team_since_wound = increment_on_key(year_in_team_since_wound, (blessure.date - blessure.user.memberships.first.year_since_join).to_i)
            else
                year_in_team_since_wound = increment_on_key(year_in_team_since_wound, nil)
            end

            if !blessure.user.participations.first.nil? &&
                !blessure.user.participations.first.position.nil?
                current_position = blessure.user.participations.first.position
                positions = increment_on_key(positions, blessure.user.participations.first.position.name)
            else
                positions = increment_on_key(positions, nil)
            end

            # year and month
            if date[blessure.date.year.to_s][blessure.date.month] == nil #initialize the hash value if it doesn't exist
                date[blessure.date.year.to_s][blessure.date.month] = 0
            end
            date[blessure.date.year.to_s][blessure.date.month] += 1

            # sports
            if blessure.equipe_type
                sports = increment_on_key(sports, blessure.equipe_type.name)
            end

            # types
            types = increment_on_key(types, blessure.type_de_blessure_name)

            # teams
            if !(params[:multi_equipe_select] == "0" || params[:multi_equipe_select] == nil || params[:multi_equipe_select][0] == "0")
                if params[:multi_equipe_select].is_a? Array
                    teams = Equipe.find(params[:multi_equipe_select]) #only declare injuries for the specified team
                else
                    teams = [Equipe.find(params[:multi_equipe_select].to_i)]
                end
            else
                #if no specified team declare injuries for all teams the player plays on
                teams = blessure.user.equipes
            end
            teams.each do |team|
                if !team.is_a? Numeric
                    if equipes[team.name] == nil
                        equipes[team.name] = 0
                    end
                    equipes[team.name] += 1
                end
            end
        end

        #Sorting calc data by desc value
        equipes = sort_hash_reverse_value(equipes)
        types = sort_hash_reverse_value(types)
        sports = sort_hash_reverse_value(sports)
        sex = sort_hash_reverse_value(sex)
        blessures_by_member_type = sort_hash_reverse_value(blessures_by_member_type)
        positions = sort_hash_reverse_value(positions)
        year_in_team_since_wound = sort_hash_reverse_value(year_in_team_since_wound)

        #put data into labels and charts - bar graph for time
        i = 0
        @bar_labels = @@chart_month_labels
        @year_labels = []
        @bar_chart_data = []
        date.each do |year, months|
            @year_labels << year.to_s
            month_data = [0,0,0,0,0,0,0,0,0,0,0,0] #initialize all months to 0
            months.each do |month_number, blessures|
                month_data[month_number - 1] = blessures
            end
            @bar_chart_data[i] = { fillColor: @@chart_year_colors[i], strokeColor: @@chart_year_colors[i], data: month_data}
            i += 1
        end

        @blessures_totals = prepare_hash_for_frontend(blessures_by_member_type)
        @sex_totals = prepare_hash_for_frontend(sex)
        @position_totals = prepare_hash_for_frontend(positions)
        @year_wounds_totals = prepare_hash_for_frontend(year_in_team_since_wound)

        #put data into labels and charts - pie graph for sports
        i = 0
        @sport_labels = []
        @pie_data_sport = []
        sports.each do |sport_name, blessures|
            @sport_labels.push(:name=>"#{sport_name}", :count=>"#{blessures.to_s}")
            @pie_data_sport[i] = {value: blessures, color: @@pie_chart_colors[i]}
            i += 1
        end
        #put data into labels and charts - pie graph for teams
        i = 0
        @team_labels = []
        @pie_data_team = []
        equipes.each do |team_name, blessures|
            @team_labels.push(:name=>"#{team_name}", :count=>"#{blessures.to_s}")
            @pie_data_team[i] = {value: blessures, color: @@pie_chart_colors[i]}
            i += 1
        end
        #put data into labels and charts - pie graph for types
        i = 0
        @type_labels = []
        @pie_data_type = []
        types.each do |type_name, blessures|
            @type_labels.push(:name=>"#{type_name}", :count=>"#{blessures.to_s}")
            @pie_data_type[i] = {value: blessures, color: @@pie_chart_colors[i]}
            i += 1
        end

        @sport_picker = [[I18n.t(:general_all), 0]]
        EquipeType.all.each do |equipe|
            @sport_picker << [equipe.name, equipe.id]
        end

        @bodypart_picker = [[I18n.t(:general_all), I18n.t(:general_all)]]
        Bodypart.all.each do |bp|
            @bodypart_picker << [bp.name, bp.code]
        end

        @type_de_blessure_picker = [[I18n.t(:general_all), I18n.t(:general_all)]]
        Blessuretype.all.each do |bt|
            @type_de_blessure_picker << [bt.name, bt.code]
        end


        @team_picker = [[I18n.t(:general_all), 0]]
        @all_teams.each do |equipe|
            @team_picker << [equipe.name, equipe.id]
        end
    end
end
