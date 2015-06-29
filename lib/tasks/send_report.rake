require "#{Rails.root}/app/helpers/email_helper.rb"
require "#{Rails.root}/app/helpers/aggregation_helper.rb"
require "#{Rails.root}/app/helpers/statistics_helper.rb"
require "#{Rails.root}/app/helpers/sessions_helper.rb"
require 'open-uri'
include AggregationHelper
include StatisticsHelper
include EmailHelper
include SessionsHelper
  task :send_report => :environment do
	REPORT_CONTENT = IO.read("#{Rails.root}/app/assets/emails/report_email.html")

	  tasks = ReportTask.order(:id).where(:deleted => 0)
		firstofyear = Date.today.beginning_of_year
		firstofmonth = Date.today.beginning_of_month
  	firstofweek = Date.today.beginning_of_week
  	today = Date.today

  	tasks.each do |task|  
  		date = task.last_date
  		interval = ""
  		valid = false
  		if task.frequency == 1 #weekly
  			if date < firstofweek
  				valid = true
  			end
        interval = "Hebdomadaire"
  		elsif task.frequency == 2 #monthly
			if date < firstofmonth
  				valid = true
  			end
        interval = "Mensuel"
  		elsif task.frequency == 3 #yearly
  			if date < firstofyear
  				valid = true
  			end
        interval = "Annuel"
  		end

  		if valid
          reportHistory = ReportHistory.new
          reportHistory.equipe_select = task.equipe_select
          reportHistory.report_type = task.report_type
          reportHistory.user_id = task.user_id

          if task.frequency == 1 #weekly
            start_date = today - 1.weeks
          elsif task.frequency == 2 #monthly
            start_date = today - 1.months
          elsif task.frequency == 3 #yearly
            start_date = today - 1.years
          end
          
          reportHistory.start_date = start_date
          reportHistory.end_date = today
          reportHistory.evaluation = task.evaluation
          reportHistory.eval_test_id = task.eval_test_id
          reportHistory.organization_id = task.organization_id
          reportHistory.report_task_id = task.id

          reportHistory.save
          task.last_date = today

  		    user = User.find(task.user_id)

  		    puts(task.id)
          puts(reportHistory.id)
  		    msg = REPORT_CONTENT % [user.name, user.email , interval, "#{start_date} au #{today}", "http://www.solutionadn.com/report/#{reportHistory.id}"]
  		    send_email(user.email, msg)
          #send_email("yan.boisjoly@fdcanada.ca", msg)
  		    task.save
  		end
  	end
  end

  task :getTask => :environment do
  	tasks = ReportTask.order(:id).all

  	tasks.each do |task|
  		puts task.id
  	end
  end
  task :get_env => :environment do
  	puts Rails.env
  end

  task :get_pdf => :environment do
  	#http://localhost:3000/users/700/ajax_result_eval?utf8=%E2%9C%93&end_date_eval%5B%5D=2015-04-20&start_date_eval%5B%5D=2015-04-13&eval_test_id=&commit=Appliquer
  	#http://localhost:3000/users/700/ajax_result_blessure?utf8=%E2%9C%93&end_date_rapport%5B%5D=2015-04-13&start_date_rapport%5B%5D=2015-04-06&equipe_select%5B%5D=0&commit=Appliquer
  	params = ActionController::Parameters.new
  	#params[:end_date_eval] = "2015-04-20".to_date
  	#puts params[:end_date_eval]
  	#params[:start_date_eval] = "2015-04-13".to_date
  	params[:bp_select] = "Tous"
	params[:sex_select] = "Tous"
	params[:sport_select] = "0"
	params[:tb_select] = "Tous"
  	params[:eval_test_id] = nil
  	params[:end_date_rapport] = "2015-04-20".to_date
  	params[:start_date_rapport] = "2010-04-13".to_date
  	params[:end_date] = "2015-04-20"
  	params[:start_date] = "2010-04-13"
  	params[:equipe_select] = "0"
  	params[:evaluation] = "2"
  	@user = User.find(700)
  	Organization.current_organization = 14
    @participe_equipes = @user.equipes
    @admin_equipes = Equipe.where(:user_id => @user.id)
    #@evaluation = Evaluation.find(2)
    if is_user_in_role?(@user, 'DIR')
      collect_director_stats(params)
    end
    if is_user_in_any_role?(@user, ['TRAINER', 'PHYSIO'])
      collect_trainer_stats(params)
    end
    #puts params
    ac = ActionController::Base.new()
    # :locals => {:variable => variable},:partial => 'something/template'
    #html = ac.render_to_string(:partial => "#{Rails.root}/app/views/users/user_eval_rapport.html.erb", :format => :html)
    WickedPdf.config = {
	  exe_path: "#{Rails.root}/bin/wkhtmltopdf-amd64"
	}
    html = ac.render_to_string(:partial => 'users/user_blessure_rapport_graphics')
    pdf = WickedPdf.new.pdf_from_string(html)
        hash = Digest::MD5.hexdigest(DateTime.now.strftime("%Y-%m-%d %H:%M:%S"))
        while(File::exists?( Rails.root.join('public', 'uploads',hash) )) do
          hash = Digest::MD5.hexdigest(DateTime.now.strftime("%Y-%m-%d %H:%M:%S"))
        end
        File.open(Rails.root.join('public', 'uploads',hash+".pdf"), 'wb') do |file|
          file << pdf
        end
    #send_data(pdf,
    #:filename => "my_pdf_name.pdf",
    #:disposition => 'attachment')
  end